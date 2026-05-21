<#
.SYNOPSIS
    Windows SOCKS5 Proxy to Hotspot TUN Adapter Bridge Launcher.
    Must be run as Administrator.
#>

# 1. Force Administrator Elevation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 2. Setup Working Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$BinDir = Join-Path $ScriptDir "bin"
$ConfigFile = Join-Path $BinDir "config.yaml"
$Tun2SocksExe = Join-Path $BinDir "tun2socks.exe"

# 3. Create GUI Window Frame
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Xbox & Phone Proxy Hotspot Bridge"
$Form.Size = New-Object System.Drawing.Size(420, 320)
$Form.StartPosition = "CenterScreen"
$Form.FormBorderStyle = "FixedSingle"
$Form.MaximizeBox = $false

# Port Input Label
$PortLabel = New-Object System.Windows.Forms.Label
$PortLabel.Text = "Psiphon SOCKS5 Port:"
$PortLabel.Location = New-Object System.Drawing.Point(20, 30)
$PortLabel.Size = New-Object System.Drawing.Size(130, 20)
$Form.Controls.Add($PortLabel)

# Port Input Box
$PortInput = New-Object System.Windows.Forms.TextBox
$PortInput.Text = "4568"
$PortInput.Location = New-Object System.Drawing.Point(160, 27)
$PortInput.Size = New-Object System.Drawing.Size(80, 20)
$Form.Controls.Add($PortInput)

# Status Indicator Label
$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Text = "STATUS: DISCONNECTED"
$StatusLabel.ForeColor = [System.Drawing.Color]::Red
$StatusLabel.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$StatusLabel.Location = New-Object System.Drawing.Point(20, 75)
$StatusLabel.Size = New-Object System.Drawing.Size(360, 25)
$Form.Controls.Add($StatusLabel)

# Action Trigger Button
$StartButton = New-Object System.Windows.Forms.Button
$StartButton.Text = "Start Tunnel Bridge"
$StartButton.Location = New-Object System.Drawing.Point(20, 110)
$StartButton.Size = New-Object System.Drawing.Size(360, 40)
$StartButton.BackColor = [System.Drawing.Color]::LightGray
$Form.Controls.Add($StartButton)

# Explanatory Information Label
$InfoLabel = New-Object System.Windows.Forms.Label
$InfoLabel.Text = "Note: Ensure you have manually set the 'XboxBridge' network adapter IPv4 properties to 10.66.66.2 and enabled internet connection sharing over your mobile hotspot adapter inside 'ncpa.cpl'."
$InfoLabel.Location = New-Object System.Drawing.Point(20, 170)
$InfoLabel.Size = New-Object System.Drawing.Size(360, 60)
$InfoLabel.ForeColor = [System.Drawing.Color]::Gray
$Form.Controls.Add($InfoLabel)

# Global tracking variable for background processing execution
$Global:JobProcess = $null

# 4. Engine Toggle Execution Logic
$StartButton.Add_Click({
    if ($Global:JobProcess -eq $null) {
        # Check dependencies
        if (-not (Test-Path $Tun2SocksExe)) {
            [System.Windows.Forms.MessageBox]::Show("Error: tun2socks.exe not found in bin folder!", "Missing Dependency")
            return
        }

        # Write or overwrite configuration dynamically matching current input values
        $YamlContent = @"
proxy: socks5://127.0.0.1:$($PortInput.Text)
device: tun://XboxBridge
loglevel: info
tcp-auto-tuning: true
"@
        Set-Content -Path $ConfigFile -Value $YamlContent

        # Spin up engine quietly in background thread
        $StartInfo = New-Object System.Diagnostics.ProcessStartInfo
        $StartInfo.FileName = $Tun2SocksExe
        $StartInfo.Arguments = "-config `"$ConfigFile`""
        $StartInfo.WorkingDirectory = $BinDir
        $StartInfo.CreateNoWindow = $true
        $StartInfo.UseShellExecute = $false
        
        $Global:JobProcess = [System.Diagnostics.Process]::Start($StartInfo)

        # Update App UI State
        $StatusLabel.Text = "STATUS: ACTIVE (Bridging to port $($PortInput.Text))"
        $StatusLabel.ForeColor = [System.Drawing.Color]::Green
        $StartButton.Text = "Stop Tunnel Bridge"
        $StartButton.BackColor = [System.Drawing.Color]::LightCoral
        $PortInput.Enabled = $false
    } else {
        # Gracefully stop backend application tracking
        if ($Global:JobProcess -and -not $Global:JobProcess.HasExited) {
            $Global:JobProcess.Kill()
        }
        $Global:JobProcess = $null
        Stop-Process -Name "tun2socks" -ErrorAction SilentlyContinue

        # Revert App UI State back to waiting status
        $StatusLabel.Text = "STATUS: DISCONNECTED"
        $StatusLabel.ForeColor = [System.Drawing.Color]::Red
        $StartButton.Text = "Start Tunnel Bridge"
        $StartButton.BackColor = [System.Drawing.Color]::LightGray
        $PortInput.Enabled = $true
    }
})

# Clean teardown safety trigger if user exits app window abruptly
$Form.Add_FormClosing({
    if ($Global:JobProcess -and -not $Global:JobProcess.HasExited) {
        $Global:JobProcess.Kill()
    }
    Stop-Process -Name "tun2socks" -ErrorAction SilentlyContinue
})

[System.Windows.Forms.Application]::Run($Form)