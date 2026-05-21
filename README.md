# Windows SOCKS5 Proxy Hotspot Bridge 🚀

A lightweight GUI utility script to cleanly route local proxy servers (like Psiphon, v2rayN, or SSH Tunnels) through a dedicated virtual network card straight to your Windows Mobile Hotspot without breaking your PC's primary internet connection. Perfect for hooking up Xbox, PlayStation, Switch, or smart devices.

## ⚙️ Initial One-Time Setup

1. Clone or download this repository to your desktop.
2. **Download Core Dependencies:** The core routing engine files (`tun2socks.exe` and `wintun.dll`) are missing by default. Follow the step-by-step download guide located inside the [/bin/ folder README](./bin/README.md) to grab them securely and place them in the correct folder.
3. Right-click `ProxyHotspotBridge.ps1` and choose **Run with PowerShell**.
4. Click **Start Tunnel Bridge** once to initialize the adapter profile inside your operating system.
5. Press `Win + R`, type `ncpa.cpl`, and hit Enter.
6. Look for the newly generated interface card named **XboxBridge**. Right-click it -> **Properties** -> Double-click **IPv4**, and change the settings manually to:
   - **IP Address:** `10.66.66.2`
   - **Subnet Mask:** `255.255.255.0`
   - **Default Gateway:** `10.66.66.1`
   - **DNS:** `1.1.1.1`
7. Click **OK**. Switch to the **Sharing** tab, check the authorization box, select your Windows **Mobile Hotspot** interface network from the dropdown choice box, and click save.

## 🎮 How To Use Every Day

1. Turn on your primary proxy engine app (e.g., Psiphon) and make note of the active SOCKS5 port.
2. Turn on your Windows Mobile Hotspot toggle.
3. Right-click `ProxyHotspotBridge.ps1`, choose **Run with PowerShell**, enter your proxy port, and click **Start**.
4. Connect your phone or gaming console to the hotspot network. Everything will instantly route cleanly out through the background network pipeline!