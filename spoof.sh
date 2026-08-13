#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script with sudo."
  exit 1
fi

if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME=$HOME
fi
PYTHON_BIN="$USER_HOME/ios-spoof-env/bin/python3"

LAT=${1:-48.8584}
LON=${2:-2.2945}

TUNNEL_PID=""

cleanup() {
    echo -e "\n\n🧹 Restoring real location..."
    # 2>/dev/null hides the spam if usbmuxd crashes
    if [ -n "$(idevice_id -l 2>/dev/null)" ]; then
        $PYTHON_BIN -m pymobiledevice3 developer dvt simulate-location clear --tunnel ""
    else
        echo "⚠️  Device disconnected. Cannot clear location via script (Reboot iPhone to reset)."
    fi
    
    echo "🛑 Stopping background tunnel..."
    kill $TUNNEL_PID 2>/dev/null
    
    echo "✅ All done! Safe travels."
    exit 0
}

trap cleanup SIGINT

# Main monitoring loop
while true; do
    echo "⏳ Waiting for iPhone to connect (check your cable)..."
    # Hide the "Unable to retrieve device list!" error spam while waiting
    while [ -z "$(idevice_id -l 2>/dev/null)" ]; do
        sleep 2
    done
    echo "✅ iPhone detected via USB!"

    echo "⚙️  Starting CoreDevice tunnel in the background..."
    $PYTHON_BIN -m pymobiledevice3 remote tunneld > /dev/null 2>&1 &
    TUNNEL_PID=$!
    
    # Give the tunnel time to initialize
    sleep 4

    echo "💿 Mounting Developer Disk Image..."
    # Suppress the "already mounted" error message so the console stays clean
    $PYTHON_BIN -m pymobiledevice3 mounter auto-mount --tunnel "" 2>/dev/null || true

    echo "📍 Teleporting to $LAT, $LON..."
    
    # Capture the tool's output to check for the word ERROR
    SPOOF_OUTPUT=$($PYTHON_BIN -m pymobiledevice3 developer dvt simulate-location set --tunnel "" -- "$LAT" "$LON" 2>&1)
    
    if echo "$SPOOF_OUTPUT" | grep -q "ERROR"; then
        # The tool failed. Print the error and restart the loop.
        echo "$SPOOF_OUTPUT"
        echo -e "\n❌ Connection failed (cable dropped or tunnel crashed). Retrying in 3s..."
        kill $TUNNEL_PID 2>/dev/null
        sleep 3
    else
        # It actually succeeded
        echo ""
        echo "🌍 Location spoofed successfully!"
        echo "⚠️  Keep this terminal open. Press [Ctrl+C] to stop spoofing and exit."
        
        # Continuously monitor if the device stays connected
        while [ -n "$(idevice_id -l 2>/dev/null)" ]; do
            sleep 3
        done
        
        echo -e "\n⚠️  iPhone disconnected! Restarting search process..."
        kill $TUNNEL_PID 2>/dev/null
    fi
done
