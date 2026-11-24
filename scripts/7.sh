# Magi-Casper (Port 5000)
cat << 'EOF' > /root/casper.sh
#!/bin/bash
grep -q 8.8.8.8 /etc/resolv.conf || echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
apt-get update && apt-get install -y iptables netcat-traditional
pkill -f "nc.traditional" 2>/dev/null
: > /tmp/casper.log
(while true; do nc.traditional -l -p 5000 >> /tmp/casper.log 2>&1; done) </dev/null >/dev/null 2>&1 &
EOF
chmod +x /root/casper.sh && /root/casper.sh

# Magi-Balthasar (Port 5000 & 5001)
cat << 'EOF' > /root/balthasar.sh
#!/bin/bash
grep -q 8.8.8.8 /etc/resolv.conf || echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
apt-get update && apt-get install -y iptables netcat-traditional
pkill -f "nc.traditional" 2>/dev/null
: > /tmp/balthasar_5000.log
: > /tmp/balthasar_5001.log
(while true; do nc.traditional -l -p 5000 >> /tmp/balthasar_5000.log 2>&1; done) </dev/null >/dev/null 2>&1 &
(while true; do nc.traditional -l -p 5001 >> /tmp/balthasar_5001.log 2>&1; done) </dev/null >/dev/null 2>&1 &
EOF
chmod +x /root/balthasar.sh && /root/balthasar.sh

# Magi-Melchior (Port 5000)
cat << 'EOF' > /root/melchior.sh
#!/bin/bash
grep -q 8.8.8.8 /etc/resolv.conf || echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
apt-get update && apt-get install -y iptables netcat-traditional
pkill -f "nc.traditional" 2>/dev/null
: > /tmp/melchior.log
(while true; do nc.traditional -l -p 5000 >> /tmp/melchior.log 2>&1; done) </dev/null >/dev/null 2>&1 &
EOF
chmod +x /root/melchior.sh && /root/melchior.sh

# Kirim pesan dari Lilith
echo "Halo Casper (5000) dari Lilith" | nc -w 1 10.87.4.58 5000
echo "Halo Balthasar (5000) dari Lilith" | nc -w 1 10.87.4.59 5000
echo "Halo Balthasar (5001) dari Lilith" | nc -w 1 10.87.4.59 5001
echo "Halo Melchior (5000) dari Lilith" | nc -w 1 10.87.4.60 5000

# Cek log di masing-masing Magi
cat /tmp/casper.log
head -n 5 /tmp/balthasar_5000.log /tmp/balthasar_5001.log
cat /tmp/melchior.log