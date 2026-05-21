hostnamectl set-hostname br-srv.au-team.irpo; exec bash
mkdir -p /etc/net/ifaces/ens18
cat > /etc/net/ifaces/ens18/options <<'EOF'
DISABLE=no
TYPE=eth
BOOTPROTO=static
CONFIG_IPV4=yes
EOF
cat > /etc/net/ifaces/ens18/ipv4address <<'EOF'
192.168.3.10/28
EOF
cat > /etc/net/ifaces/ens18/ipv4route <<'EOF'
default via 192.168.3.1
EOF
systemctl restart network
ip -c a
useradd sshuser -u 2026
echo "sshuser:P@ssw0rd" | chpasswd
echo "WHEEL_USERS ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
gpasswd -a sshuser wheel
echo "Authorized access only" > /etc/openssh/banner
sed -i 's/^#*Port .*/Port 2014/' /etc/openssh/sshd_config
sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication yes/' /etc/openssh/sshd_config
cat >> /etc/openssh/sshd_config <<'EOF'
AllowUsers sshuser
MaxAuthTries 2
Banner /etc/openssh/banner
EOF
systemctl restart sshd
timedatectl set-timezone Asia/Yekaterinburg
