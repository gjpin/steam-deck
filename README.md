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