#!/bin/bash
# НАСТРОЙКА HQ-SRV

IFACE="ens20"  # если у вас ens18 — поменяйте здесь один раз

mkdir -p /etc/net/ifaces/$IFACE

cat > /etc/net/ifaces/$IFACE/options <<'EOF'
DISABLE=no
TYPE=eth
BOOTPROTO=static
CONFIG_IPV4=yes
EOF

cat > /etc/net/ifaces/$IFACE/ipv4address <<'EOF'
192.168.1.10/27
EOF

cat > /etc/net/ifaces/$IFACE/ipv4route <<'EOF'
default via 192.168.1.1
EOF

systemctl restart network

# Пользователь
useradd sshuser -u 2026
echo "sshuser:P@ssw0rd" | chpasswd
echo "WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
gpasswd -a sshuser wheel

# SSH
echo "Authorized access only" > /etc/openssh/banner
sed -i 's/^#*Port .*/Port 2026/' /etc/openssh/sshd_config
sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication yes/' /etc/openssh/sshd_config
cat >> /etc/openssh/sshd_config <<'EOF'
AllowUsers sshuser
MaxAuthTries 2
Banner /etc/openssh/banner
EOF
systemctl restart sshd

# DNS + DNSmasq
systemctl disable --now bind 2>/dev/null
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apt-get update && apt-get install -y dnsmasq

cat > /etc/dnsmasq.conf <<'EOF'
no-resolv
domain=au-team.irpo
server=8.8.8.8
interface=*

address=/hq-rtr.au-team.irpo/192.168.1.1
address=/hq-srv.au-team.irpo/192.168.1.10
address=/hq-cli.au-team.irpo/192.168.2.10
address=/br-rtr.au-team.irpo/192.168.3.1
address=/br-srv.au-team.irpo/192.168.3.10
address=/docker.au-team.irpo/172.16.1.1
address=/web.au-team.irpo/172.16.2.1

ptr-record=1.1.168.192.in-addr.arpa,hq-rtr.au-team.irpo
ptr-record=10.1.168.192.in-addr.arpa,hq-srv.au-team.irpo
ptr-record=10.2.168.192.in-addr.arpa,hq-cli.au-team.irpo
EOF

echo "192.168.1.1	hq-rtr.au-team.irpo" >> /etc/hosts
systemctl enable --now dnsmasq

# Часовой пояс
timedatectl set-timezone Asia/Yekaterinburg