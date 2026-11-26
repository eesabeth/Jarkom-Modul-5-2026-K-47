#!/bin/bash
# Rekap Konfigurasi Praktikum - Soal 13 (Brankas Balthasar)
# Target: Magi-Balthasar (10.87.4.59) - Port TCP 5000 & 5001
# ====================================================================


# ==========================================
# 1. NODE MAGI-BALTHASAR (TARGET / FIREWALL)
# ==========================================
# Membuat script firewall /root/balthasar.sh
cat << 'EOF' > /root/balthasar.sh
#!/bin/bash

# Daftar IP yang diizinkan mengakses TCP 5000 & 5001
IP_CASPER="10.87.4.58"
IP_UNIT01="10.87.4.66"
IP_UNIT02="10.87.4.67"
IP_UNIT00="10.87.4.68"
IP_SACHIEL="10.87.3.130"

# Reset rule filter agar bersih dan tidak dobel saat dijalankan ulang
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# 1. Izinkan loopback & balasan koneksi keluar Balthasar (agar ping 8.8.8.8 tetap berjalan)
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 2. Izinkan hanya Magi-Casper dan semua Pilot ke TCP 5000 & 5001
for IP in "$IP_CASPER" "$IP_UNIT01" "$IP_UNIT02" "$IP_UNIT00" "$IP_SACHIEL"; do
    iptables -A INPUT -p tcp -s "$IP" --dport 5000 -j ACCEPT
    iptables -A INPUT -p tcp -s "$IP" --dport 5001 -j ACCEPT
done

# 3. Tolak seketika (TCP Reset) koneksi lain ke port 5000 & 5001 agar tidak timeout
iptables -A INPUT -p tcp --dport 5000 -j REJECT --reject-with tcp-reset
iptables -A INPUT -p tcp --dport 5001 -j REJECT --reject-with tcp-reset

echo "[OK] Firewall Brankas Balthasar aktif."
EOF

# Beri izin eksekusi dan jalankan script firewall
chmod +x /root/balthasar.sh
bash /root/balthasar.sh

# Cek daftar rule iptables yang terpasang
iptables -L INPUT -v -n

# Menyalakan listener netcat pada port 5000 & 5001 di background
nohup sh -c 'while true; do nc -l -p 5000; done' >/tmp/nc5000.log 2>&1 &
nohup sh -c 'while true; do nc -l -p 5001; done' >/tmp/nc5001.log 2>&1 &
ps aux | grep nc

# Pengujian ping dari Balthasar ke Internet (Harus berhasil)
ping -c 3 8.8.8.8


# ==========================================
# 2. NODE UNIT-01 (PILOT - PENGUJIAN AKSES DIIZINKAN)
# ==========================================
# Pengujian koneksi TCP ke port 5000 & 5001 Magi-Balthasar (Harus berhasil / open)
nc -vz 10.87.4.59 5000
nc -vz 10.87.4.59 5001


# ==========================================
# 3. NODE LILITH (STAF GEOFRONT - PENGUJIAN AKSES DITOLAK)
# ==========================================
# Pengujian koneksi TCP ke port 5000 & 5001 Magi-Balthasar (Harus langsung Connection refused)
nc -vz 10.87.4.59 5000
nc -vz 10.87.4.59 5001


# ==========================================
# 4. NODE MAGI-MELCHIOR (TETANGGA SATU SWITCH - PENGUJIAN AKSES DITOLAK)
# ==========================================
# Pengujian koneksi TCP ke port 5000 & 5001 Magi-Balthasar (Harus langsung Connection refused)
nc -vz 10.87.4.59 5000
nc -vz 10.87.4.59 5001