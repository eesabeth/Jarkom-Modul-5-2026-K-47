# Pen-Pen (10.87.3.194) — Port TCP 80
cat << 'EOF' > /root/penpen.sh
#!/bin/bash
grep -q 8.8.8.8 /etc/resolv.conf || echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
apt-get update && apt-get install -y iptables netcat-traditional
pkill -f "nc.traditional" 2>/dev/null

printf '#!/bin/sh\necho "Welcome to $(hostname)"\n' > /usr/local/bin/reply80.sh
chmod +x /usr/local/bin/reply80.sh

(while true; do nc.traditional -l -p 80 -e /usr/local/bin/reply80.sh; done) </dev/null >/dev/null 2>&1 &
EOF
chmod +x /root/penpen.sh && /root/penpen.sh

# Tokyo3-Core (10.87.4.106) — Port TCP 80 dan 8080
cat << 'EOF' > /root/tokyo3core.sh
#!/bin/bash
grep -q 8.8.8.8 /etc/resolv.conf || echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
apt-get update && apt-get install -y iptables netcat-traditional
pkill -f "nc.traditional" 2>/dev/null

printf '#!/bin/sh\necho "Welcome to $(hostname)"\n' > /usr/local/bin/reply80.sh
printf '#!/bin/sh\necho "syifa imutz"\n' > /usr/local/bin/reply8080.sh
chmod +x /usr/local/bin/reply80.sh /usr/local/bin/reply8080.sh

(while true; do nc.traditional -l -p 80 -e /usr/local/bin/reply80.sh; done) </dev/null >/dev/null 2>&1 &
(while true; do nc.traditional -l -p 8080 -e /usr/local/bin/reply8080.sh; done) </dev/null >/dev/null 2>&1 &
EOF
chmod +x /root/tokyo3core.sh && /root/tokyo3core.sh

# Lilith
nc 10.87.3.194 80
nc 10.87.4.106 80
nc 10.87.4.106 8080
nc -v 10.87.3.194 22
nc -v 10.87.4.106 22