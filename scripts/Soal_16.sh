#!/bin/bash
# Rekap Konfigurasi Praktikum - Soal 16 (Pencuri yang Mencoba Setiap Pintu)
# Target: Tokyo3-Core (10.87.4.106) - Log & Blokir Scan Port 22, 23, 3306 dari Dummy-Plug
# ======================================================================================


# ==========================================
# 1. NODE TOKYO3-CORE (KONFIGURASI FIREWALL & LAYANAN)
# ==========================================
# Memperbarui /root/tokyo3-core.sh (menggabungkan Soal 15 & Soal 16 agar tidak menimpa)
cat << 'EOF' > /root/tokyo3-core.sh
#!/bin/bash

IP_DUMMY="10.87.4.51"

# Reset rule filter agar bersih dan tidak dobel saat dijalankan ulang
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# 1. Izinkan loopback
iptables -A INPUT -i lo -j ACCEPT

# 2. [SOAL 15] Batasi ping masuk (echo-request) maksimal 5 ping/detik, buang kelebihannya
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/sec --limit-burst 5 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# 3. Izinkan balasan koneksi & balasan ping keluar Tokyo3-Core
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 4. [SOAL 16] Catat & tolak seketika (TCP Reset) koneksi dari Dummy-Plug ke port 22, 23, dan 3306
for PORT in 22 23 3306; do
    iptables -A INPUT -p tcp -s "$IP_DUMMY" --dport "$PORT" -j LOG --log-prefix "SCAN-NERV: " --log-level 4
    iptables -A INPUT -p tcp -s "$IP_DUMMY" --dport "$PORT" -j REJECT --reject-with tcp-reset
done

echo "[OK] Proteksi Soal 15 & Anti-Scan Dummy-Plug (Soal 16) aktif di Tokyo3-Core."
EOF

# Beri izin eksekusi dan jalankan script
chmod +x /root/tokyo3-core.sh
bash /root/tokyo3-core.sh

# Pastikan layanan TCP port 80 & 8080 berjalan di background
nohup sh -c 'while true; do echo "Welcome to Tokyo3-Core" | nc -l -p 80 -q 1; done' >/dev/null 2>&1 &
nohup sh -c 'while true; do echo "syifa imutz" | nc -l -p 8080 -q 1; done' >/dev/null 2>&1 &
ps aux | grep nc


# ==========================================
# 2. NODE DUMMY-PLUG (PENGUJIAN PORT TERLARANG & NORMAL)
# ==========================================
# Uji akses ke port sensitif 22, 23, dan 3306 (Harus langsung ditolak / Connection refused)
nc -w 2 -vz 10.87.4.106 22
nc -w 2 -vz 10.87.4.106 23
nc -w 2 -vz 10.87.4.106 3306

# Uji akses ke port layanan normal 80 dan 8080 (Harus berhasil)
nc -w 2 10.87.4.106 80
nc -w 2 10.87.4.106 8080


# ==========================================
# 3. NODE LILITH (PENGUJIAN KLIEN LAIN TIDAK TERGANGGU)
# ==========================================
# Uji akses ke port 80 dan 8080 dari klien lain (Harus berhasil)
nc -w 2 10.87.4.106 80
nc -w 2 10.87.4.106 8080


# ==========================================
# 4. NODE TOKYO3-CORE (CEK COUNTER LOG SCAN-NERV:)
# ==========================================
# Tunjukkan counter rule LOG prefix "SCAN-NERV: " untuk port 22, 23, dan 3306 naik
iptables -L INPUT -v -n