#!/bin/bash
#sed -i 's/\r$//' isp.sh
mkdir -p /etc/net/ifaces/ens18 /etc/net/ifaces/ens19 /etc/net/ifaces/ens20

cat > /etc/net/ifaces/ens18/options <<'EOF'
DISABLE=no
TYPE=eth
BOOTPROTO=dhcp
CONFIG_IPV4=yes
EOF

cat > /etc/net/ifaces/ens19/options <<'EOF'
DISABLE=no
TYPE=eth
BOOTPROTO=static
CONFIG_IPV4=yes
EOF

cat > /etc/net/ifaces/ens20/options <<'EOF'
DISABLE=no
TYPE=eth
BOOTPROTO=static
CONFIG_IPV4=yes
EOF

cat > /etc/net/ifaces/ens19/ipv4address <<'EOF'
172.16.1.1/28
EOF

cat > /etc/net/ifaces/ens20/ipv4address <<'EOF'
172.16.2.1/28
EOF

echo "net.ipv4.ip_forward = 1" >> /etc/net/sysctl.conf
systemctl restart network

apt-get update && apt-get install iptables -y

iptables -t nat -A POSTROUTING -o ens18 -s 172.16.1.0/28 -j MASQUERADE
iptables -t nat -A POSTROUTING -o ens18 -s 172.16.2.0/28 -j MASQUERADE
iptables-save > /etc/sysconfig/iptables
systemctl enable --now iptables
