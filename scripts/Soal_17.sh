#!/bin/bash
# Rekap Konfigurasi Praktikum - Soal 17 (Sihir Hitam di Jalur Paket)
# Target Router: Fuyutsuki (Gateway Switch-Terminal)
# Pengalihan TCP: Magi-Casper (10.87.4.58) -> Zeruel (10.87.4.82) dibelokkan ke Pen-Pen (10.87.3.194)
# ================================================================================================


# ==========================================
# 1. NODE FUYUTSUKI (ROUTER - KONFIGURASI DNAT)
# ==========================================
# Membuat script pengalihan trafik TCP /root/fuyutsuki.sh
cat << 'EOF' > /root/fuyutsuki.sh
#!/bin/bash

IP_CASPER="10.87.4.58"
IP_ZERUEL="10.87.4.82"
IP_PENPEN="10.87.3.194"

# Hapus aturan lama jika script dijalankan ulang agar tidak dobel
iptables -t nat -D PREROUTING -p tcp -s "$IP_CASPER" -d "$IP_ZERUEL" -j DNAT --to-destination "$IP_PENPEN" 2>/dev/null

# Belokkan hanya koneksi TCP dari Magi-Casper ke Zeruel agar menuju Pen-Pen
iptables -t nat -A PREROUTING -p tcp -s "$IP_CASPER" -d "$IP_ZERUEL" -j DNAT --to-destination "$IP_PENPEN"

echo "[OK] Pengalihan TCP Casper -> Zeruel ke Pen-Pen aktif di Fuyutsuki."
EOF

# Beri izin eksekusi dan jalankan script
chmod +x /root/fuyutsuki.sh
bash /root/fuyutsuki.sh

# Verifikasi rule DNAT di tabel nat
iptables -t nat -L PREROUTING -v -n

# Konfigurasi DNS resolver & pasang paket conntrack untuk melihat tabel koneksi
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apt-get update && apt-get install -y conntrack


# ==========================================
# 2. NODE PEN-PEN & ZERUEL (LISTENER PORT 9000)
# ==========================================
# [Di Pen-Pen (10.87.3.194)] Nyalakan listener port 9000 (akan menerima pesan pengalihan)
nc -l -p 9000

# [Di Zeruel (10.87.4.82)] Nyalakan listener port 9000 (akan tetap kosong)
nc -l -p 9000


# ==========================================
# 3. NODE MAGI-CASPER (PENGIRIMAN PESAN & CEK CONNTRACK)
# ==========================================
# [Di Magi-Casper (10.87.4.58)] Hubungkan ke IP Zeruel port 9000 dan ketik pesan
# Pesan akan masuk ke Pen-Pen, sedangkan Zeruel tetap kosong
nc 10.87.4.82 9000
# Input pesan: Halo Zeruel dari Magi-Casper

# [Di Fuyutsuki] Tampilkan tabel conntrack saat koneksi berlangsung (atau segera setelahnya)
conntrack -L

# [Di Magi-Casper] Setelah mengecek conntrack, tutup nc (Ctrl+C) lalu uji ping ke Zeruel
# Ping tidak memakai protokol TCP sehingga tidak ikut dialihkan (harus berhasil)
ping -c 3 10.87.4.82