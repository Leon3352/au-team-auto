#!/bin/bash
IFACE="ens18"

mkdir -p /etc/net/ifaces/ens18
cat > /etc/net/ifaces/ens18/options <<'EOF'
DISABLE=no
TYPE=eth
BOOTPROTO=dhcp
EOF

systemctl restart network
timedatectl set-timezone Asia/Yekaterinburg
