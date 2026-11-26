#!/bin/bash
# Rekap Konfigurasi Praktikum - Soal 20 (Babak Final: Uji Kebakaran Geofront)
# Simulasi Pemusnahan & Pemulihan Idempoten Rule Firewall/NAT serta Rute Statis
# Target Pengujian (3 Node): Router Shigeru, Router Fuyutsuki, dan Host Tokyo3-Core
# ==================================================================================


# ==================================================================================
# 1. NODE 1: ROUTER SHIGERU
# ==================================================================================
# A. Simpan rule iptables & buat script pemulihan rute statis yang idempoten
iptables-save > /root/shigeru.rules

cat << 'EOF' > /root/shigeru.sh
#!/bin/bash
ip route replace default via 10.87.4.153 dev eth0
ip route replace 10.87.4.88/29 via 10.87.4.158 dev eth1
EOF
chmod +x /root/shigeru.sh

# B. Simulasi kebakaran (hapus seluruh rule filter/nat dan rute statis)
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

ip route del default
ip route del 10.87.4.88/29

# Cek kondisi kosong sebelum pemulihan
iptables -S
iptables -t nat -S
ip route

# C. Pemulihan pertama & kedua (jumlah baris rule dan rute harus identik)
iptables-restore < /root/shigeru.rules
bash /root/shigeru.sh
echo "--- Pemulihan 1 (Shigeru) ---"
echo "Jumlah baris filter: $(iptables -S | wc -l)"
echo "Jumlah baris nat   : $(iptables -t nat -S | wc -l)"
ip route

iptables-restore < /root/shigeru.rules
bash /root/shigeru.sh
echo "--- Pemulihan 2 (Shigeru) ---"
echo "Jumlah baris filter: $(iptables -S | wc -l)"
echo "Jumlah baris nat   : $(iptables -t nat -S | wc -l)"
ip route

# D. Verifikasi fungsi jaringan Shigeru kembali normal
# [Di Magi-Casper] ping -c 2 10.87.4.82   -> Berhasil (0% packet loss)
# [Di Lilith]      ping -c 2 10.87.4.82   -> Gagal (100% packet loss)
# [Di Zeruel]      ping -c 2 8.8.8.8      -> Berhasil (0% packet loss)


# ==================================================================================
# 2. NODE 2: ROUTER FUYUTSUKI
# ==================================================================================
# A. Simpan rule iptables (termasuk tabel nat DNAT) & buat script pemulihan rute statis
iptables-save > /root/fuyutsuki.rules

cat << 'EOF' > /root/fuyutsuki.sh
#!/bin/bash
ip route replace default via 10.87.4.161 dev eth0
ip route replace 10.87.3.192/27 via 10.87.4.166 dev eth2
ip route replace 10.87.4.72/29 via 10.87.4.170 dev eth1
EOF
chmod +x /root/fuyutsuki.sh

# B. Simulasi kebakaran (hapus seluruh rule filter/nat dan rute statis)
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

ip route del default
ip route del 10.87.3.192/27
ip route del 10.87.4.72/29

# Cek kondisi kosong sebelum pemulihan
iptables -S
iptables -t nat -S
ip route

# C. Pemulihan pertama & kedua (jumlah baris rule dan rute harus identik)
iptables-restore < /root/fuyutsuki.rules
bash /root/fuyutsuki.sh
echo "--- Pemulihan 1 (Fuyutsuki) ---"
echo "Jumlah baris filter: $(iptables -S | wc -l)"
echo "Jumlah baris nat   : $(iptables -t nat -S | wc -l)"
ip route

iptables-restore < /root/fuyutsuki.rules
bash /root/fuyutsuki.sh
echo "--- Pemulihan 2 (Fuyutsuki) ---"
echo "Jumlah baris filter: $(iptables -S | wc -l)"
echo "Jumlah baris nat   : $(iptables -t nat -S | wc -l)"
ip route

# D. Verifikasi fungsi jaringan & DNAT Fuyutsuki kembali normal
# [Di Magi-Casper] ping -c 2 10.87.4.74   -> Berhasil (rute ke Switch-Dogma pulih)
# [Di Magi-Casper] ping -c 2 8.8.8.8      -> Berhasil (rute default pulih)
# [Di Pen-Pen]     nc -l -p 9000
# [Di Magi-Casper] echo "Tes setelah kebakaran Fuyutsuki" | nc -w 2 10.87.4.82 9000 -> Masuk ke Pen-Pen


# ==================================================================================
# 3. NODE 3: HOST TOKYO3-CORE
# ==================================================================================
# A. Simpan rule iptables & buat script pemulihan rute default
iptables-save > /root/tokyo3-core.rules

cat << 'EOF' > /root/tokyo3-core.sh
#!/bin/bash
ip route replace default via 10.87.4.105 dev eth0
EOF
chmod +x /root/tokyo3-core.sh

# B. Simulasi kebakaran (hapus seluruh rule dan rute default)
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

ip route del default

# Cek kondisi kosong sebelum pemulihan
iptables -S
ip route

# C. Pemulihan pertama & kedua (jumlah baris rule dan rute harus identik)
iptables-restore < /root/tokyo3-core.rules
bash /root/tokyo3-core.sh
echo "--- Pemulihan 1 (Tokyo3-Core) ---"
echo "Jumlah baris filter: $(iptables -S | wc -l)"
echo "Jumlah baris nat   : $(iptables -t nat -S | wc -l)"
ip route

iptables-restore < /root/tokyo3-core.rules
bash /root/tokyo3-core.sh
echo "--- Pemulihan 2 (Tokyo3-Core) ---"
echo "Jumlah baris filter: $(iptables -S | wc -l)"
echo "Jumlah baris nat   : $(iptables -t nat -S | wc -l)"
ip route

# D. Verifikasi fungsi jaringan & firewall Tokyo3-Core kembali normal
# [Di Tokyo3-Core] ping -c 2 8.8.8.8             -> Berhasil (rute default pulih)
# [Di Dummy-Plug]  nc -w 2 -vz 10.87.4.106 22    -> Langsung ditolak (Connection refused)