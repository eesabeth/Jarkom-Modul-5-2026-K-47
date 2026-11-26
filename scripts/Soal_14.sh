#!/bin/bash
# Rekap Konfigurasi Praktikum - Soal 14 (Jam Kunjungan Sang Pinguin)
# Target: Pen-Pen (10.87.3.194) - ICMP Ping & TCP Port 80
# ====================================================================


# ==========================================
# 1. NODE PEN-PEN (KONFIGURASI UTAMA / JADWAL ASLI)
# ==========================================
# Membuat script firewall /root/penpen.sh (Konversi UTC = WIB - 7 jam)
cat << 'EOF' > /root/penpen.sh
#!/bin/bash

# Variabel jadwal wajib (Konversi UTC = WIB - 7 jam)
PILOT_START="01:00"
PILOT_STOP="09:00"
PILOT_DAYS="Mon,Tue,Wed,Thu,Fri"
STAF_START="10:00"
STAF_STOP="16:00"

# Daftar IP per kategori
IP_PILOT=("10.87.4.66" "10.87.4.67" "10.87.4.68" "10.87.3.130")
IP_STAF=("10.87.4.74" "10.87.4.75")
IP_DUMMY=("10.87.4.51" "10.87.4.50" "10.87.4.102")

# Reset rule filter agar bersih
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Izinkan loopback & balasan koneksi keluar Pen-Pen
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 1. Terduga Dummy System: selalu ditolak untuk ping & TCP 80
for IP in "${IP_DUMMY[@]}"; do
    iptables -A INPUT -s "$IP" -p icmp --icmp-type echo-request -j DROP
    iptables -A INPUT -s "$IP" -p tcp --dport 80 -j REJECT --reject-with tcp-reset
done

# 2. Pilot: hanya boleh pada jam & hari jadwal, selain itu ditolak
for IP in "${IP_PILOT[@]}"; do
    iptables -A INPUT -s "$IP" -p icmp --icmp-type echo-request -m time --timestart "$PILOT_START" --timestop "$PILOT_STOP" --weekdays "$PILOT_DAYS" -j ACCEPT
    iptables -A INPUT -s "$IP" -p tcp --dport 80 -m time --timestart "$PILOT_START" --timestop "$PILOT_STOP" --weekdays "$PILOT_DAYS" -j ACCEPT
    iptables -A INPUT -s "$IP" -p icmp --icmp-type echo-request -j DROP
    iptables -A INPUT -s "$IP" -p tcp --dport 80 -j REJECT --reject-with tcp-reset
done

# 3. Staf Geofront: hanya boleh pada jam jadwal setiap hari, selain itu ditolak
for IP in "${IP_STAF[@]}"; do
    iptables -A INPUT -s "$IP" -p icmp --icmp-type echo-request -m time --timestart "$STAF_START" --timestop "$STAF_STOP" -j ACCEPT
    iptables -A INPUT -s "$IP" -p tcp --dport 80 -m time --timestart "$STAF_START" --timestop "$STAF_STOP" -j ACCEPT
    iptables -A INPUT -s "$IP" -p icmp --icmp-type echo-request -j DROP
    iptables -A INPUT -s "$IP" -p tcp --dport 80 -j REJECT --reject-with tcp-reset
done

echo "[OK] Jadwal Pen-Pen aktif (Jam UTC saat ini: $(date -u '+%a %H:%M'))."
EOF

# Beri izin eksekusi dan jalankan script
chmod +x /root/penpen.sh
bash /root/penpen.sh

# Cek daftar rule iptables dan nyalakan layanan TCP 80
iptables -L INPUT -v -n
nohup sh -c 'while true; do echo "Welcome to Pen-Pen" | nc -l -p 80 -q 1; done' >/dev/null 2>&1 &


# ==========================================
# 2. PENGUJIAN KONDISI 1 (JADWAL COCOK JAM SEKARANG)
# ==========================================
# [Di Pen-Pen] Ubah variabel agar mencakup jam UTC sekarang
sed -i 's/^PILOT_START=.*/PILOT_START="00:00"/' /root/penpen.sh
sed -i 's/^PILOT_STOP=.*/PILOT_STOP="23:59"/' /root/penpen.sh
sed -i 's/^PILOT_DAYS=.*/PILOT_DAYS="Mon,Tue,Wed,Thu,Fri,Sat,Sun"/' /root/penpen.sh
sed -i 's/^STAF_START=.*/STAF_START="00:00"/' /root/penpen.sh
sed -i 's/^STAF_STOP=.*/STAF_STOP="23:59"/' /root/penpen.sh
bash /root/penpen.sh

# [Di Unit-01] Harus berhasil (0% packet loss & Welcome to Pen-Pen)
ping -c 3 10.87.3.194
nc -w 2 10.87.3.194 80

# [Di Lilith] Harus berhasil (0% packet loss & Welcome to Pen-Pen)
ping -c 3 10.87.3.194
nc -w 2 10.87.3.194 80

# [Di Spy] Harus selalu ditolak (100% packet loss & Connection refused)
ping -c 3 10.87.3.194
nc -w 2 -vz 10.87.3.194 80


# ==========================================
# 3. PENGUJIAN KONDISI 2 (JADWAL TIDAK COCOK JAM SEKARANG)
# ==========================================
# [Di Pen-Pen] Ubah rentang jam ke luar jam UTC saat ini
sed -i 's/^PILOT_START=.*/PILOT_START="01:00"/' /root/penpen.sh
sed -i 's/^PILOT_STOP=.*/PILOT_STOP="02:00"/' /root/penpen.sh
sed -i 's/^STAF_START=.*/STAF_START="01:00"/' /root/penpen.sh
sed -i 's/^STAF_STOP=.*/STAF_STOP="02:00"/' /root/penpen.sh
bash /root/penpen.sh

# [Di Unit-01] Harus gagal (100% packet loss)
ping -c 3 10.87.3.194

# [Di Lilith] Harus gagal (100% packet loss)
ping -c 3 10.87.3.194

# [Di Spy] Harus gagal (100% packet loss)
ping -c 3 10.87.3.194


# ==========================================
# 4. KEMBALIKAN VARIABEL KE JADWAL ASLI SOAL
# ==========================================
# [Di Pen-Pen] Kembalikan jadwal UTC sesuai soal (08.00-16.00 & 17.00-23.00 WIB)
sed -i 's/^PILOT_START=.*/PILOT_START="01:00"/' /root/penpen.sh
sed -i 's/^PILOT_STOP=.*/PILOT_STOP="09:00"/' /root/penpen.sh
sed -i 's/^PILOT_DAYS=.*/PILOT_DAYS="Mon,Tue,Wed,Thu,Fri"/' /root/penpen.sh
sed -i 's/^STAF_START=.*/STAF_START="10:00"/' /root/penpen.sh
sed -i 's/^STAF_STOP=.*/STAF_STOP="16:00"/' /root/penpen.sh
bash /root/penpen.sh