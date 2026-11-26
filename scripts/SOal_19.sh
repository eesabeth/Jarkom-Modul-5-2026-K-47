#!/bin/bash
# Rekap Konfigurasi Praktikum - Soal 19 (Hukuman untuk Sang Pengkhianat)
# Target Isolasi: Armisael (IP: 10.87.4.83 | MAC: 02:42:96:f9:2b:00)
# Eksekutor Isolasi: Router Shigeru (Gateway) & Node Zeruel (Tetangga Satu Switch)
# =================================================================================


# ==========================================
# 1. NODE SHIGERU (ROUTER - ISOLASI GATEWAY & JARINGAN LUAR)
# ==========================================
# Memperbarui /root/shigeru.sh (menggabungkan isolasi Armisael Soal 19 & zona sensitif Soal 18)
cat << 'EOF' > /root/shigeru.sh
#!/bin/bash

IF_GENDOU="eth0"
SUBNET_TERMINAL="10.87.4.56/29"
IP_ARMISAEL="10.87.4.83"
MAC_ARMISAEL="02:42:96:f9:2b:00"

# Reset rule filter agar bersih dan tidak dobel saat dijalankan ulang
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# === [SOAL 19] ISOLASI TOTAL ARMISAEL DARI GATEWAY & JARINGAN LUAR ===
iptables -A INPUT -m mac --mac-source "$MAC_ARMISAEL" -j DROP
iptables -A INPUT -s "$IP_ARMISAEL" -j DROP
iptables -A OUTPUT -d "$IP_ARMISAEL" -j DROP
iptables -A FORWARD -m mac --mac-source "$MAC_ARMISAEL" -j DROP
iptables -A FORWARD -s "$IP_ARMISAEL" -j DROP
iptables -A FORWARD -d "$IP_ARMISAEL" -j DROP

# === [SOAL 18] GERBANG ZONA SENSITIF (SWITCH-MONOLITH & SWITCH-RADAR) ===
# 1. Izinkan balasan koneksi yang dimulai dari dalam zona sensitif ke luar
iptables -A FORWARD -i "$IF_GENDOU" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 2. Pengecualian tunggal: izinkan ping masuk dari subnet Switch-Terminal
iptables -A FORWARD -i "$IF_GENDOU" -s "$SUBNET_TERMINAL" -p icmp --icmp-type echo-request -j ACCEPT

# 3. Blokir semua trafik baru lainnya yang datang dari arah Gendou (-i eth0)
iptables -A FORWARD -i "$IF_GENDOU" -j DROP

echo "[OK] Isolasi Armisael (Soal 19) & Gerbang Zona Sensitif (Soal 18) aktif di Shigeru."
EOF

# Beri izin eksekusi dan jalankan script
chmod +x /root/shigeru.sh
bash /root/shigeru.sh

# Cek daftar rule di Shigeru
iptables -L -v -n


# ==========================================
# 2. NODE ZERUEL (ISOLASI TETANGGA SATU SWITCH)
# ==========================================
# Membuat script firewall /root/zeruel.sh untuk memutus komunikasi satu switch dengan Armisael
cat << 'EOF' > /root/zeruel.sh
#!/bin/bash

IP_ARMISAEL="10.87.4.83"
MAC_ARMISAEL="02:42:96:f9:2b:00"

# Reset rule filter di Zeruel
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Blokir total seluruh lalu lintas dari dan menuju Armisael (satu switch)
iptables -A INPUT -m mac --mac-source "$MAC_ARMISAEL" -j DROP
iptables -A INPUT -s "$IP_ARMISAEL" -j DROP
iptables -A OUTPUT -d "$IP_ARMISAEL" -j DROP

echo "[OK] Isolasi satu switch dengan Armisael aktif di Zeruel."
EOF

# Beri izin eksekusi dan jalankan script
chmod +x /root/zeruel.sh
bash /root/zeruel.sh

# Cek daftar rule di Zeruel
iptables -L -v -n


# ==========================================
# 3. NODE ARMISAEL, ZERUEL, & LILITH (LISTENER TCP 9000)
# ==========================================
# Jalankan perintah berikut di masing-masing console Armisael, Zeruel, dan Lilith
nohup sh -c 'while true; do nc -l -p 9000; done' >/tmp/nc9000.log 2>&1 &
ps aux | grep nc


# ==========================================
# 4. NODE ARMISAEL (PENGUJIAN ISOLASI TOTAL - SEMUA HARUS GAGAL)
# ==========================================
# Catatan: Tidak ada aturan iptables yang dipasang di dalam Armisael
# Uji ping ke Seele (8.8.8.8), Zeruel (10.87.4.82), dan Lilith (10.87.4.74) -> Semua 100% packet loss
ping -c 2 8.8.8.8
ping -c 2 10.87.4.82
ping -c 2 10.87.4.74

# Uji nc ke Seele (TCP 53), Zeruel (TCP 9000), dan Lilith (TCP 9000) -> Semua gagal / timed out
nc -w 2 -vz 8.8.8.8 53
nc -w 2 -vz 10.87.4.82 9000
nc -w 2 -vz 10.87.4.74 9000


# ==========================================
# 5. NODE ZERUEL (PENGUJIAN KONEKSI NORMAL - SEMUA HARUS BERHASIL)
# ==========================================
# Uji ping dari Zeruel (10.87.4.82) ke Seele dan Lilith -> Harus 0% packet loss
ping -c 2 8.8.8.8
ping -c 2 10.87.4.74

# Uji nc dari Zeruel ke Seele (TCP 53) dan kirim pesan ke Lilith (TCP 9000) -> Harus berhasil
nc -w 2 -vz 8.8.8.8 53
echo "Pesan dari Zeruel" | nc -w 2 10.87.4.74 9000


# ==========================================
# 6. NODE LILITH (VERIFIKASI PESAN ZERUEL & BLOKIR KE ARMISAEL)
# ==========================================
# Cek pesan yang masuk dari Zeruel pada listener TCP 9000
cat /tmp/nc9000.log

# Uji koneksi TCP 9000 ke Armisael (10.87.4.83) -> Harus gagal / timed out
nc -w 2 -vz 10.87.4.83 9000