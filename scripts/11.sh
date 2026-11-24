# Magi-Casper
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Test ping dari Lilith ke Casper, Balthasar ke Casper
ping -c 2 10.87.4.58

# Test ping dari Casper ke Lilith, Casper ke Balthasar
ping -c 2 10.87.4.59 && ping -c 2 10.87.4.74