#!/bin/bash
# Rekap Konfigurasi Praktikum - Soal 18 (Gerbang Monolith dan Radar)
# Target Router: Shigeru (Penjaga Zona Sensitif Switch-Monolith & Switch-Radar)
# Interface ke Gendou: eth0 | Pengecualian Subnet Terminal: 10.87.4.56/29
# ==============================================================================


# ==========================================
# 1. NODE SHIGERU (ROUTER - KONFIGURASI FIREWALL)
# ==========================================
# Membuat script firewall zona sensitif /root/shigeru.sh
cat << 'EOF' > /root/shigeru.sh
#!/bin/bash

IF_GENDOU="eth0"
SUBNET_TERMINAL="10.87.4.56/29"

# Reset rule filter agar bersih dan tidak dobel saat dijalankan ulang
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# === [SOAL 18] GERBANG ZONA SENSITIF (SWITCH-MONOLITH & SWITCH-RADAR) ===
# 1. Izinkan balasan koneksi yang dimulai dari dalam zona sensitif ke luar
iptables -A FORWARD -i "$IF_GENDOU" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 2. Pengecualian tunggal: izinkan ping (ICMP echo-request) masuk dari subnet Switch-Terminal
iptables -A FORWARD -i "$IF_GENDOU" -s "$SUBNET_TERMINAL" -p icmp --icmp-type echo-request -j ACCEPT

# 3. Blokir semua trafik baru lainnya yang datang dari arah Gendou (-i eth0)
iptables -A FORWARD -i "$IF_GENDOU" -j DROP

echo "[OK] Gerbang Zona Sensitif (Soal 18) aktif di Shigeru."
EOF

# Beri izin eksekusi dan jalankan script
chmod +x /root/shigeru.sh
bash /root/shigeru.sh

# Cek daftar rule FORWARD yang terpasang
iptables -L FORWARD -v -n


# ==========================================
# 2. NODE MAGI-CASPER (PENGUJIAN PENGECUALIAN TERMINAL)
# ==========================================
# Ping dari Magi-Casper (10.87.4.58) ke Zeruel (10.87.4.82) -> Harus berhasil (0% packet loss)
ping -c 3 10.87.4.82


# ==========================================
# 3. NODE LILITH (PENGUJIAN AKSES LUAR DITOLAK)
# ==========================================
# Ping dari Lilith (10.87.4.74) ke Zeruel (10.87.4.82) -> Harus gagal (100% packet loss)
ping -c 3 10.87.4.82


# ==========================================
# 4. NODE ZERUEL (PENGUJIAN KONEKSI KELUAR DARI DALAM ZONA)
# ==========================================
# Ping dari dalam zona (Zeruel 10.87.4.82) ke Lilith dan Internet -> Harus berhasil
ping -c 3 10.87.4.74
ping -c 3 8.8.8.8


# ==========================================
# 5. NODE SHIGERU (VERIFIKASI COUNTER BLOKIR)
# ==========================================
# Cek kenaikan counter pkts pada baris DROP all -- eth0 *
iptables -L FORWARD -v -n