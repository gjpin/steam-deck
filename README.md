# Setup Guide

1. Setup user password: `passwd`
2. mkdir -p ${HOME}/.ssh
2. Add public key to ${HOME}/.ssh/authorized_keys
3. Setup SSHD:
```bash
sudo tee /etc/ssh/sshd_config << EOF
Port 22
PermitRootLogin no
AuthorizedKeysFile      .ssh/authorized_keys
PasswordAuthentication no
PermitEmptyPasswords no
UsePAM yes
PrintMotd no
Subsystem       sftp    /usr/lib/ssh/sftp-server
EOF
```
4. Enable SSHD: `sudo systemctl enable --now sshd.service`
5. Create Wireguard folder: `sudo mkdir -p /etc/wireguard`
6. Copy Wireguard config to `/etc/wireguard/wg0.conf`
7. Import wireguard connection to networkmanager: `sudo nmcli con import type wireguard file /etc/wireguard/wg0.conf`

# Moonlight steam shortcuts
```
"/usr/bin/flatpak"

flatpak run --command="moonlight" com.moonlight_stream.Moonlight stream --help
```

## 800p
```
"run" "--branch=stable" "--arch=x86_64" "--command=moonlight" "com.moonlight_stream.Moonlight" "--resolution=1280x800" "--vsync" "--fps=60" "--bitrate=12000" "--packet-size=1392" "--display-mode=borderless" "--audio-config=stereo" "--multi-controller" "--quit-after" "--no-mouse-buttons-swap" "--no-game-optimization" "--no-audio-on-host" "--frame-pacing" "--mute-on-focus-loss" "--no-swap-gamepad-buttons" "--keep-awake" "--no-performance-overlay" "--no-hdr" "--video-codec=AV1" "--video-decoder=hardware" stream "10.100.100.250" "Desktop 800p"
```

## 1080p
```
"run" "--branch=stable" "--arch=x86_64" "--command=moonlight" "com.moonlight_stream.Moonlight" "--resolution= 1920x1080" "--vsync" "--fps=60" "--bitrate=40000" "--packet-size=1392" "--display-mode=fullscreen" "--audio-config=stereo" "--multi-controller" "--quit-after" "--no-mouse-buttons-swap" "--no-game-optimization" "--no-audio-on-host" "--frame-pacing" "--mute-on-focus-loss" "--no-swap-gamepad-buttons" "--keep-awake" "--no-performance-overlay" "--no-hdr" "--video-codec=AV1" "--video-decoder=hardware" stream "10.100.100.250" "Desktop 1080p"
```

## 1440p
```
"run" "--branch=stable" "--arch=x86_64" "--command=moonlight" "com.moonlight_stream.Moonlight" "--resolution=2560x1440" "--vsync" "--fps=60" "--bitrate=120000" "--packet-size=1392" "--display-mode=fullscreen" "--audio-config=stereo" "--multi-controller" "--quit-after" "--no-mouse-buttons-swap" "--no-game-optimization" "--no-audio-on-host" "--frame-pacing" "--mute-on-focus-loss" "--no-swap-gamepad-buttons" "--keep-awake" "--no-performance-overlay" "--no-hdr" "--video-codec=AV1" "--video-decoder=hardware" stream "10.100.100.250" "Desktop 1440p"
```