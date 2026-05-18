#!/bin/bash
# НАСТРОЙКА CLI

IFACE="ens20"  # или ens18

mkdir -p /etc/net/ifaces/$IFACE
cat > /etc/net/ifaces/$IFACE/options <<'EOF'
DISABLE=no
TYPE=eth
BOOTPROTO=dhcp
EOF

systemctl restart network
timedatectl set-timezone Asia/Yekaterinburg