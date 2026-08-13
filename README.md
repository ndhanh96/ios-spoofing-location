# iOS 17+ Location Spoofer for Linux (Ubuntu)

A robust, auto-reconnecting bash script to spoof the GPS location of an iPhone running iOS 17 or newer from an Ubuntu Linux machine. 

## 📖 Background
Starting with iOS 17, Apple completely overhauled how developer tools communicate with iPhones. They replaced the standard USB communication with a network-based protocol called **CoreDevice** (and **DVT** for developer actions), which can be notoriously unstable on Linux. 

This repository provides a wrapper script around `pymobiledevice3` to establish a background tunnel to the device, bypass CLI parser quirks (like negative coordinates crashing the tool), and constantly monitor the connection so that if your USB cable wiggles, it will automatically recover and re-establish the connection.

---

## ⚙️ Prerequisites

### 1. Enable Developer Mode on the iPhone
Apple requires explicit consent to use developer features like location simulation.
1. Go to **Settings** > **Privacy & Security**.
2. Scroll to the bottom and tap **Developer Mode**.
3. Toggle it **On** and allow the device to restart.
4. Unlock the device and tap **Turn On** when prompted.

### 2. Install Ubuntu Dependencies
You will need the standard Apple USB multiplexer and Python tools installed on your host machine.
```bash
sudo apt update
sudo apt install usbmuxd libimobiledevice-utils python3-pip python3-venv git
```

---

## 🛠️ Installation

**1. Clone the repository**
```bash
git clone [https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git](https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git)
cd YOUR-REPO-NAME
```
*(Note: Be sure to replace the URL with your actual repository link).*

**2. Create a Dedicated Python Environment**
To prevent conflicts with your system's Python or package managers like Anaconda, the script expects `pymobiledevice3` to be installed in a dedicated virtual environment in your home folder.
```bash
python3 -m venv ~/ios-spoof-env
~/ios-spoof-env/bin/pip install pymobiledevice3
```

**3. Make the script executable**
```bash
chmod +x spoof.sh
