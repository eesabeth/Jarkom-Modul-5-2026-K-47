# Config IP Forwarding
# Gendou
cat << 'EOF' > /root/gendo.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1

# Interface IP (Soal 2)
ip link set eth0 up
ip addr replace 10.87.4.109/30 dev eth1 && ip link set eth1 up
ip addr replace 10.87.4.125/30 dev eth2 && ip link set eth2 up
ip addr replace 10.87.4.133/30 dev eth3 && ip link set eth3 up
ip addr replace 10.87.4.145/30 dev eth4 && ip link set eth4 up
ip addr replace 10.87.4.149/30 dev eth5 && ip link set eth5 up
ip addr replace 10.87.4.153/30 dev eth6 && ip link set eth6 up
ip addr replace 10.87.4.161/30 dev eth7 && ip link set eth7 up
ip addr replace 10.87.4.105/30 dev eth8 && ip link set eth8 up

# Static Routes Cabang dengan Ringkasan CIDR (Soal 3)
# Cabang Yui (10.87.4.110)
ip route replace 10.87.0.0/23 via 10.87.4.110
ip route replace 10.87.3.0/25 via 10.87.4.110
ip route replace 10.87.4.0/27 via 10.87.4.110
ip route replace 10.87.4.32/28 via 10.87.4.110
ip route replace 10.87.4.112/29 via 10.87.4.110
ip route replace 10.87.4.120/30 via 10.87.4.110

# Cabang Hikari (10.87.4.126)
ip route replace 10.87.2.0/24 via 10.87.4.126
ip route replace 10.87.3.224/27 via 10.87.4.126
ip route replace 10.87.4.128/30 via 10.87.4.126

# Cabang Asuka (10.87.4.134)
ip route replace 10.87.3.128/26 via 10.87.4.134
ip route replace 10.87.4.48/29 via 10.87.4.134
ip route replace 10.87.4.96/30 via 10.87.4.134
ip route replace 10.87.4.136/29 via 10.87.4.134

# Cabang Kaji (10.87.4.146) & Misato (10.87.4.150)
ip route replace 10.87.4.100/30 via 10.87.4.146
ip route replace 10.87.4.64/29 via 10.87.4.150

# Cabang Shigeru (10.87.4.154)
ip route replace 10.87.4.80/28 via 10.87.4.154
ip route replace 10.87.4.156/30 via 10.87.4.154

# Cabang Fuyutsuki (10.87.4.162)
ip route replace 10.87.3.192/27 via 10.87.4.162
ip route replace 10.87.4.56/29 via 10.87.4.162
ip route replace 10.87.4.72/29 via 10.87.4.162
ip route replace 10.87.4.164/30 via 10.87.4.162
ip route replace 10.87.4.168/30 via 10.87.4.162
EOF
chmod +x /root/gendo.sh && /root/gendo.sh

# Yui
cat << 'EOF' > /root/yui.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.110/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.121/30 dev eth1 && ip link set eth1 up
ip addr replace 10.87.4.113/30 dev eth2 && ip link set eth2 up
ip addr replace 10.87.4.117/30 dev eth3 && ip link set eth3 up
ip addr replace 10.87.3.1/25 dev eth4 && ip link set eth4 up

ip route replace default via 10.87.4.109
ip route replace 10.87.4.0/27 via 10.87.4.122
ip route replace 10.87.0.0/23 via 10.87.4.114
ip route replace 10.87.4.32/28 via 10.87.4.118
EOF
chmod +x /root/yui.sh && /root/yui.sh

# Hikari
cat << 'EOF' > /root/hikari.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.126/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.129/30 dev eth1 && ip link set eth1 up
ip addr replace 10.87.2.1/24 dev eth2 && ip link set eth2 up

ip route replace default via 10.87.4.125
ip route replace 10.87.3.224/27 via 10.87.4.130
EOF
chmod +x /root/hikari.sh && /root/hikari.sh

# Asuka
cat << 'EOF' > /root/asuka.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.134/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.137/30 dev eth1 && ip link set eth1 up
ip addr replace 10.87.4.141/30 dev eth2 && ip link set eth2 up
ip addr replace 10.87.4.97/30 dev eth3 && ip link set eth3 up

ip route replace default via 10.87.4.133
ip route replace 10.87.3.128/26 via 10.87.4.138
ip route replace 10.87.4.48/29 via 10.87.4.142
EOF
chmod +x /root/asuka.sh && /root/asuka.sh

# Shigeru
cat << 'EOF' > /root/shigeru.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.154/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.157/30 dev eth1 && ip link set eth1 up
ip addr replace 10.87.4.81/29 dev eth2 && ip link set eth2 up

ip route replace default via 10.87.4.153
ip route replace 10.87.4.88/29 via 10.87.4.158
EOF
chmod +x /root/shigeru.sh && /root/shigeru.sh

# Fuyutsuki
cat << 'EOF' > /root/fuyutsuki.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.162/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.169/30 dev eth1 && ip link set eth1 up
ip addr replace 10.87.4.165/30 dev eth2 && ip link set eth2 up
ip addr replace 10.87.4.57/29 dev eth3 && ip link set eth3 up

ip route replace default via 10.87.4.161
ip route replace 10.87.4.72/29 via 10.87.4.170
ip route replace 10.87.3.192/27 via 10.87.4.166
EOF
chmod +x /root/fuyutsuki.sh && /root/fuyutsuki.sh

# Kaji
cat << 'EOF' > /root/kaji.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.146/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.101/30 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.145
EOF
chmod +x /root/kaji.sh && /root/kaji.sh

# Misato
cat << 'EOF' > /root/misato.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.150/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.65/29 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.149
EOF
chmod +x /root/misato.sh && /root/misato.sh

# Toji
cat << 'EOF' > /root/toji.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.170/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.73/29 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.169
EOF
chmod +x /root/toji.sh && /root/toji.sh

# Maya
cat << 'EOF' > /root/maya.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.166/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.3.193/27 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.165
EOF
chmod +x /root/maya.sh && /root/maya.sh

# Rei
cat << 'EOF' > /root/rei.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.114/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.0.1/23 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.113
EOF
chmod +x /root/rei.sh && /root/rei.sh

# Mari
cat << 'EOF' > /root/mari.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.118/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.33/28 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.117
EOF
chmod +x /root/mari.sh && /root/mari.sh

# Shinji
cat << 'EOF' > /root/shinji.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.122/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.1/27 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.121
EOF
chmod +x /root/shinji.sh && /root/shinji.sh

# Kaworu
cat << 'EOF' > /root/kaworu.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.130/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.3.225/27 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.129
EOF
chmod +x /root/kaworu.sh && /root/kaworu.sh

# Kensuke
cat << 'EOF' > /root/kensuke.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.138/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.3.129/26 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.137
EOF
chmod +x /root/kensuke.sh && /root/kensuke.sh

# Ritsuko
cat << 'EOF' > /root/ritsuko.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.142/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.49/29 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.141
EOF
chmod +x /root/ritsuko.sh && /root/ritsuko.sh

# Makoto
cat << 'EOF' > /root/makoto.sh
#!/bin/bash
sysctl -w net.ipv4.ip_forward=1
ip addr replace 10.87.4.158/30 dev eth0 && ip link set eth0 up
ip addr replace 10.87.4.89/29 dev eth1 && ip link set eth1 up
ip route replace default via 10.87.4.157
EOF
chmod +x /root/makoto.sh && /root/makoto.sh

# Di Gendou, cek respon 16 router lainnya
for ip in 10.87.4.110 10.87.4.126 10.87.4.134 10.87.4.146 10.87.4.150 10.87.4.154 10.87.4.162 10.87.4.114 10.87.4.118 10.87.4.122 10.87.4.130 10.87.4.138 10.87.4.142 10.87.4.158 10.87.4.166 10.87.4.170; do
  ping -c 1 -W 1 $ip > /dev/null && echo "$ip : OK" || echo "$ip : GAGAL"
done

# Cek ping antar router