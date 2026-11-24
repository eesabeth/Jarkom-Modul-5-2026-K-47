# Unit-01
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.66
    netmask 255.255.255.248
    gateway 10.87.4.65
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF

ip addr replace 10.87.4.66/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.65
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Verifikasi 2x, sebelum dan setelah di restart node nya
ip -br a
ping -c 2 10.87.4.65

# Quarters
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.0.2
    netmask 255.255.254.0
    gateway 10.87.0.1
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.0.2/23 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.0.1
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Comm-Net
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.2.2
    netmask 255.255.255.0
    gateway 10.87.2.1
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.2.2/24 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.2.1
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Hangar-Crew
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.3.2
    netmask 255.255.255.128
    gateway 10.87.3.1
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.3.2/25 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.3.1
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Sachiel
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.3.130
    netmask 255.255.255.192
    gateway 10.87.3.129
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.3.130/26 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.3.129
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Pen-Pen
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.3.194
    netmask 255.255.255.224
    gateway 10.87.3.193
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.3.194/27 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.3.193
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Medic-Bay
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.3.195
    netmask 255.255.255.224
    gateway 10.87.3.193
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.3.195/27 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.3.193
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Relay-Node
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.3.226
    netmask 255.255.255.224
    gateway 10.87.3.225
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.3.226/27 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.3.225
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Garden-Staff
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.2
    netmask 255.255.255.224
    gateway 10.87.4.1
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.2/27 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.1
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Dock-Crew
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.34
    netmask 255.255.255.240
    gateway 10.87.4.33
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.34/28 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.33
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Entry-Plug
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.50
    netmask 255.255.255.248
    gateway 10.87.4.49
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.50/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.49
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Duummy-Plug
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.51
    netmask 255.255.255.248
    gateway 10.87.4.49
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.51/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.49
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Magi-Casper
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.58
    netmask 255.255.255.248
    gateway 10.87.4.57
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.58/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.57
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Magi-Balthasar
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.59
    netmask 255.255.255.248
    gateway 10.87.4.57
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.59/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.57
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Magi-Melchior
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.60
    netmask 255.255.255.248
    gateway 10.87.4.57
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.60/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.57
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Unit-02
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.67
    netmask 255.255.255.248
    gateway 10.87.4.65
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.67/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.65
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Unit-00
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.68
    netmask 255.255.255.248
    gateway 10.87.4.65
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.68/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.65
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Lilith
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.74
    netmask 255.255.255.248
    gateway 10.87.4.73
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.74/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.73
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Adam
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.75
    netmask 255.255.255.248
    gateway 10.87.4.73
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.75/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.73
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Zeruel
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.82
    netmask 255.255.255.248
    gateway 10.87.4.81
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.82/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.81
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Armisael
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.83
    netmask 255.255.255.248
    gateway 10.87.4.81
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.83/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.81
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Radar-Array
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.90
    netmask 255.255.255.248
    gateway 10.87.4.89
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.90/29 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.89
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Archive-Vault
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.98
    netmask 255.255.255.252
    gateway 10.87.4.97
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.98/30 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.97
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Spy
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.102
    netmask 255.255.255.252
    gateway 10.87.4.101
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.102/30 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.101
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf

# Tokyo3-Core
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.87.4.106
    netmask 255.255.255.252
    gateway 10.87.4.105
    up echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf
EOF
ip addr flush dev eth0
ip addr replace 10.87.4.106/30 dev eth0 && ip link set eth0 up
ip route replace default via 10.87.4.105
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > /etc/resolv.conf