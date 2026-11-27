# Di /root/gendo.sh untuk menambahkan firewall, dan aturan lainnya
cat << 'EOF' >> /root/gendo.sh

# 5. Firewall Gendou: Kunci Pintu Depan NAT1 (Soal 5)
iptables -F
iptables -X
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Loopback & DHCP dari NAT1
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i eth0 -p udp --sport 67 --dport 68 -j ACCEPT

# (a) Balasan koneksi yang sudah ada
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# (b) Traffic dari jaringan internal ke internet (NAT1)
iptables -A FORWARD -s 10.87.0.0/21 -o eth0 -j ACCEPT

# (c) Traffic antar-LAN internal
iptables -A FORWARD -s 10.87.0.0/21 -d 10.87.0.0/21 ! -i eth0 -j ACCEPT

# (d) Traffic dari jaringan internal ke Gendou sendiri
iptables -A INPUT -s 10.87.0.0/21 ! -i eth0 -j ACCEPT
EOF
/root/gendo.sh

# Cek di Gendou, hasilnya harus sesuai rules
iptables -S

# Cek keberhasilan di Armisael
ping -c 3 8.8.8.8