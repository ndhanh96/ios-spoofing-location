# iOS 17+ Location Spoofer for Linux (Ubuntu)

A robust, auto-reconnecting bash script to spoof the GPS location of an iPhone running iOS 17 or newer from an Ubuntu Linux machine. 

## 📖 Background
Starting with iOS 17, Apple completely overhauled how developer tools communicate with iPhones. They replaced the standard USB communication with a network-based protocol called **CoreDevice** (and **DVT** for developer actions), which can be notoriously unstable on Linux. 

This script uses `pymobiledevice3` to establish a background tunnel to the device, bypass CLI parser quirks (like negative coordinates crashing the script), and constantly monitor the connection so that if your USB cable wiggles, it will automatically recover and re-establish the connection.

---

## ⚙️ Prerequisites

### 1. Enable Developer Mode on the iPhone
Apple requires explicit consent to use developer features like location simulation.
1. Go to **Settings** > **Privacy & Security**.
2. Scroll to the bottom and tap **Developer Mode**.
3. Toggle it **On** and allow the device to restart.
4. Unlock the device and tap **Turn On** when prompted.

### 2. Install Ubuntu Dependencies
You will need the standard Apple USB multiplexer and Python tools.
```bash
sudo apt update
sudo apt install usbmuxd libimobiledevice-utils python3-pip python3-venv

# Create the virtual environment in your home directory
python3 -m venv ~/ios-spoof-env

# Install the required tool
~/ios-spoof-env/bin/pip install pymobiledevice3
