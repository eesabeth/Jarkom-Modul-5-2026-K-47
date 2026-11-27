# Pasang IP Sementara
# Armisael
ip addr replace 10.87.4.83/29 dev eth0 && ip link set eth0 up && ip route replace default via 10.87.4.81

# Lilith
ip addr replace 10.87.4.74/29 dev eth0 && ip link set eth0 up && ip route replace default via 10.87.4.73

# Sachiel
ip addr replace 10.87.3.130/26 dev eth0 && ip link set eth0 up && ip route replace default via 10.87.3.129

# Comm-Net
ip addr replace 10.87.2.2/24 dev eth0 && ip link set eth0 up && ip route replace default via 10.87.2.1

# Cek di Armisael
ping -c 3 10.87.4.74
ping -c 3 10.87.3.130
ping -c 3 10.87.2.2