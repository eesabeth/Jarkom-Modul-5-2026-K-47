# Gendou
# In case butuh untuk membersihkan IP sisa scan
ip addr flush dev eth0 && ip neigh flush all && ip route del default 2>/dev/null
ip addr replace 192.168.122.2/24 dev eth0 && ip link set eth0 up
ping -b -c 2 -I eth0 255.255.255.255
ip -s link show eth0

# Ke /root/gendo.sh
cat << 'EOF' > /root/gendo.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1

# Sesuaikan 2 baris ini jika gateway NAT1 berbeda
GW_NAT1="192.168.122.1"
IP_ETH0="192.168.122.2/24"

# 1. Interface IP (Soal 2 & 4)
ip addr flush dev eth0
ip addr replace $IP_ETH0 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.109/30 dev eth1 && ip link set eth1 up
ip addr replace 10.87.4.125/30 dev eth2 && ip link set eth2 up
ip addr replace 10.87.4.133/30 dev eth3 && ip link set eth3 up
ip addr replace 10.87.4.145/30 dev eth4 && ip link set eth4 up
ip addr replace 10.87.4.149/30 dev eth5 && ip link set eth5 up
ip addr replace 10.87.4.153/30 dev eth6 && ip link set eth6 up
ip addr replace 10.87.4.161/30 dev eth7 && ip link set eth7 up
ip addr replace 10.87.4.105/30 dev eth8 && ip link set eth8 up

# 2. Default Route ke NAT1 & DNS Resolver (Soal 3 & 4)
ip route replace default via $GW_NAT1
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# 3. Static Routes Cabang dengan Ringkasan CIDR (Soal 3)
ip route replace 10.87.0.0/23 via 10.87.4.110
ip route replace 10.87.3.0/25 via 10.87.4.110
ip route replace 10.87.4.0/27 via 10.87.4.110
ip route replace 10.87.4.32/28 via 10.87.4.110
ip route replace 10.87.4.112/29 via 10.87.4.110
ip route replace 10.87.4.120/30 via 10.87.4.110

ip route replace 10.87.2.0/24 via 10.87.4.126
ip route replace 10.87.3.224/27 via 10.87.4.126
ip route replace 10.87.4.128/30 via 10.87.4.126

ip route replace 10.87.3.128/26 via 10.87.4.134
ip route replace 10.87.4.48/29 via 10.87.4.134
ip route replace 10.87.4.96/30 via 10.87.4.134
ip route replace 10.87.4.136/29 via 10.87.4.134

ip route replace 10.87.4.100/30 via 10.87.4.146
ip route replace 10.87.4.64/29 via 10.87.4.150

ip route replace 10.87.4.80/28 via 10.87.4.154
ip route replace 10.87.4.156/30 via 10.87.4.154

ip route replace 10.87.3.192/27 via 10.87.4.162
ip route replace 10.87.4.56/29 via 10.87.4.162
ip route replace 10.87.4.72/29 via 10.87.4.162
ip route replace 10.87.4.164/30 via 10.87.4.162
ip route replace 10.87.4.168/30 via 10.87.4.162

# 4. NAT Masquerade Prefix Internal menuju NAT1 (Soal 4)
iptables -t nat -F
iptables -t nat -A POSTROUTING -s 10.87.0.0/21 -o eth0 -j MASQUERADE
EOF
chmod +x /root/gendo.sh && /root/gendo.sh

# Cek Gendou 
ping -c 2 8.8.8.8
iptables -t nat -L POSTROUTING -v -n

# Cek di Armisael
ip addr replace 10.87.4.83/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.81
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
ping -c 3 8.8.8.8
ping -c 3 deb.debian.org

# Cek di Lliith
ip addr replace 10.87.4.74/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.73
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
ping -c 3 8.8.8.8
ping -c 3 deb.debian.org

# Cek lagi IP Tables di Gendou
iptables -t nat -L POSTROUTING -v -n