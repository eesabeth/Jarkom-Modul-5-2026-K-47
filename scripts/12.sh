# Magi-Casper
cat << 'EOF' > /root/casper.sh
#!/bin/bash
grep -q 8.8.8.8 /etc/resolv.conf || echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
pkill -f "nc.traditional" 2>/dev/null
: > /tmp/casper.log
(while true; do nc.traditional -l -p 5000 >> /tmp/casper.log 2>&1; done) </dev/null >/dev/null 2>&1 &

iptables -F
iptables -X
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
EOF
chmod +x /root/casper.sh && /root/casper.sh

# Cek Keberhasilan Hardening
iptables -S
ping -c 2 8.8.8.8
apt-get update

# Cek ping dari Lilith ke Casper
ping -c 2 10.87.4.58

# Cek nc dari Unit-00 ke Casper
echo "Koneksi dari Unit-00 berhasil" | nc -w 1 10.87.4.58 5000

# Cek pesan di casper.log
cat /tmp/casper.log