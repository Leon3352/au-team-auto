hostnamectl set-hostname ISP; exec bash
mkdir -p /etc/net/ifaces/ens18 /etc/net/ifaces/ens19 /etc/net/ifaces/ens20
cat > /etc/net/ifaces/ens18/options <<'EOF'
DISABLE=no
TYPE=eth
BOOTPROTO=dhcp
CONFIG_IPV4=yes
EOF
cp /etc/net/ifaces/ens18/options /etc/net/ifaces/ens19/
cp /etc/net/ifaces/ens18/options /etc/net/ifaces/ens20/
cat > /etc/net/ifaces/ens19/ipv4address <<'EOF'
172.16.70.1/28
EOF
cat > /etc/net/ifaces/ens20/ipv4address <<'EOF'
172.16.80.1/28
EOF
echo "net.ipv4.ip_forward = 1" >> /etc/net/sysctl.conf
systemctl restart network
ip -c a
apt-get update && apt-get install iptables -y
iptables -t nat -A POSTROUTING -o ens18 -s 172.16.70.0/28 -j MASQUERADE
iptables -t nat -A POSTROUTING -o ens18 -s 172.16.80.0/28 -j MASQUERADE
iptables-save > /etc/sysconfig/iptables
systemctl enable --now iptables
apt-get reinstall tzdata -y
timedatectl set-timezone Asia/Yekaterinburg
