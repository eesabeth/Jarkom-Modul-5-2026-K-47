#!/bin/bash
# Rekap Konfigurasi Praktikum - Soal 15 (Banjir Ping di Pusat Komando)
# Target: Tokyo3-Core (10.87.4.106) - Limit ICMP Echo-Request Maksimal 5 Ping/Detik
# =================================================================================


# ==========================================
# 1. NODE TOKYO3-CORE (KONFIGURASI FIREWALL)
# ==========================================
# Membuat script firewall /root/tokyo3-core.sh
cat << 'EOF' > /root/tokyo3-core.sh
#!/bin/bash

# Reset rule filter agar bersih dan tidak dobel saat dijalankan ulang
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# 1. Izinkan loopback
iptables -A INPUT -i lo -j ACCEPT

# 2. [SOAL 15] Batasi ping masuk (echo-request) maksimal 5 ping/detik, buang kelebihannya
# Diletakkan sebelum ESTABLISHED agar flood ping dari satu proses tetap terbatasi
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 5/sec --limit-burst 5 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# 3. Izinkan balasan koneksi & balasan ping (echo-reply) yang dikirim Tokyo3-Core sendiri
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

echo "[OK] Proteksi banjir ping (maksimal 5 ping/detik) aktif di Tokyo3-Core."
EOF

# Beri izin eksekusi dan jalankan script
chmod +x /root/tokyo3-core.sh
bash /root/tokyo3-core.sh

# Cek daftar rule dan counter awal
iptables -L INPUT -v -n


# ==========================================
# 2. NODE LILITH (PENGUJIAN BANJIR PING)
# ==========================================
# Kirim 50 ping rapat dengan jeda 0.1 detik (Harus ada paket yang hilang / ~40% packet loss)
ping -i 0.1 -c 50 10.87.4.106


# ==========================================
# 3. NODE TOKYO3-CORE (CEK COUNTER & PING KELUAR)
# ==========================================
# Tunjukkan counter rule DROP pada icmptype 8 naik (20 pkts terbuang)
iptables -L INPUT -v -n

# Uji ping rapat keluar dari Tokyo3-Core sendiri ke internet (Harus 0% packet loss)
ping -i 0.1 -c 15 8.8.8.8


# ==========================================
# 4. NODE LILITH (PENGUJIAN PING NORMAL)
# ==========================================
# Kirim ping biasa dengan jeda minimal 3 detik (Harus 0% packet loss / semua berhasil)
ping -i 3 -c 5 10.87.4.106