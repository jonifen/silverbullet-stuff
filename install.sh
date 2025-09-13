mkdir -p /opt/silverbullet/space
mkdir -p /opt/silverbullet/bin

wget https://github.com/silverbulletmd/silverbullet/releases/download/2.0.0/silverbullet-server-linux-x86_64.zip

unzip silverbullet-server-linux-x86_64.zip -d /opt/silverbullet/bin

cat <<EOF >/etc/systemd/system/silverbullet.service
[Unit]
Description=Silverbullet Daemon
After=syslog.target network.target

[Service]
User=root
Type=simple
ExecStart=/opt/silverbullet/bin/silverbullet --hostname 0.0.0.0 --port 3000 /opt/silverbullet/space
WorkingDirectory=/opt/silverbullet
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
systemctl enable --now -q silverbullet

echo "Service installed"
