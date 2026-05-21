# Core Dependencies Download Guide 🛠️

To keep this repository lightweight and respect original open-source software licenses, the binary execution engines are not bundled directly with this script. You need to download two small, official files manually to make the bridge function.

Please follow these exact steps to obtain them:

### Step 1: Download `tun2socks.exe`
1. Head over to the official **xjasonlyu/tun2socks** GitHub releases page:  
   👉 [https://github.com/xjasonlyu/tun2socks/releases](https://github.com/xjasonlyu/tun2socks/releases)
2. Look for the latest release version at the top of the page.
3. Under the **Assets** dropdown for that release, click and download the Windows 64-bit zip file. It is typically named:  
   `tun2socks-windows-amd64.zip`
4. Open the downloaded zip file, extract **ONLY** the `tun2socks.exe` file, and paste it directly into this `/bin/` folder.

---

### Step 2: Download `wintun.dll`
1. Go to the official **Wintun** driver homepage managed by the WireGuard project:  
   👉 [https://www.wintun.net/](https://www.wintun.net/)
2. Scroll down or click the prominent **Download Wintun** link to download the official zip file package.
3. Open the downloaded `wintun-x.xx.zip` file.
4. Open the **`amd64`** folder inside that zip archive.
5. Copy the **`wintun.dll`** file from that folder and paste it directly into this `/bin/` folder alongside your `tun2socks.exe`.

---

### Final Check Verification
Before launching the application launcher script, ensure your `/bin/` folder contains exactly these files:
```text
 ┗ 📂 bin
   ┣ 📄 README.md        (This file)
   ┣ 📄 tun2socks.exe    (Extracted from step 1)
   ┗ 📄 wintun.dll       (Extracted from step 2)