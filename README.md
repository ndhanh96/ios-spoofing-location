# iOS 17+ Location Spoofer for Linux (Ubuntu)

A robust, auto-reconnecting Bash script to spoof the GPS location of an iPhone running iOS 17 or newer from an Ubuntu Linux machine. 

## 📖 Background
Starting with iOS 17, Apple completely overhauled how developer tools communicate with iPhones. They replaced the standard USB communication with a network-based protocol called **CoreDevice** (and **DVT** for developer actions), which can be notoriously unstable on Linux. 

This repository provides a wrapper script around `pymobiledevice3` to establish a background tunnel to the device, bypass CLI parser quirks (like negative coordinates crashing the tool), and constantly monitor the connection so that if your USB cable is bumped, the script automatically recovers and re-establishes the tunnel.

---

## ⚙️ Prerequisites

### 1. Enable Developer Mode on the iPhone
Apple requires explicit consent to use developer features like location simulation.
1. Go to **Settings** > **Privacy & Security**.
2. Scroll to the bottom and tap **Developer Mode**.
3. Toggle it **On** and allow the device to restart.
4. Unlock the device and tap **Turn On** when prompted.

### 2. Install Ubuntu Dependencies
You will need the standard Apple USB multiplexer and `curl` installed on your host machine.
```bash
sudo apt update
sudo apt install usbmuxd libimobiledevice-utils curl git
```

---

## 🛠️ Installation

**1. Clone the repository**
```bash
git clone <URL_TO_THIS_REPO>
cd <REPO_DIRECTORY>
```

**2. Install uv (Fast Python Package Manager)**
This script uses `uv` to manage an isolated Python environment. Run the standalone installer and then refresh your terminal:
```bash
curl -LsSf [https://astral.sh/uv/install.sh](https://astral.sh/uv/install.sh) | sh
source $HOME/.local/bin/env
```

**3. Create a Dedicated Python Environment**
To prevent conflicts with your system's packages, create a dedicated virtual environment in your home folder and install `pymobiledevice3`:
```bash
uv venv ~/ios-spoof-env
uv pip install pymobiledevice3 --python ~/ios-spoof-env
```

**4. Make the script executable**
```bash
chmod +x spoof.sh
```

---

## 🚀 Usage

Ensure your iPhone is plugged in, unlocked, and that you have selected **Trust This Computer**.

**To spoof to the default location (Eiffel Tower, Paris):**
```bash
sudo ./spoof.sh
```

**To spoof to custom coordinates (e.g., Central Park, NY):**
```bash
sudo ./spoof.sh 40.7812 -73.9665
```

**To stop spoofing:**
Simply press `Ctrl + C` in the terminal running the script. The script will automatically clear the simulated location, tear down the CoreDevice tunnel, and restore your real GPS signal.

---

## 🚑 Troubleshooting

* **Script gets stuck in an "ERROR" loop:** Unplug the iPhone, run `sudo systemctl restart usbmuxd`, and plug it back in.
* **Location is stuck after unplugging:** If your script crashes or you unplug the phone before pressing `Ctrl + C`, the simulated location will persist. **Reboot your iPhone** to permanently wipe the developer simulation and restore your actual location.
* **Sometimes it takes a few seconds to a minute** to return to your real location after stopping the script.
