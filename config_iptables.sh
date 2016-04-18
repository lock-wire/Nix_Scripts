#!/bin/sh

#This Script configure iptables
#created by R. Lemus and shared

iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT   -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A OUTPUT  -m state --state INVALID -j DROP

iptables -A INPUT -s 10.0.0.0/8       -j DROP
#iptables -A INPUT -s 127.0.0.0/8      -j DROP
iptables -A INPUT -s 169.254.0.0/16   -j DROP
#iptables -A INPUT -s 172.16.0.0/12    -j DROP
iptables -A INPUT -s 192.168.0.0/16   -j DROP
iptables -A INPUT -s 224.0.0.0/4      -j DROP
iptables -A INPUT -d 224.0.0.0/4      -j DROP
iptables -A INPUT -s 240.0.0.0/5      -j DROP
iptables -A INPUT -d 240.0.0.0/5      -j DROP
iptables -A INPUT -s 0.0.0.0/8        -j DROP
iptables -A INPUT -d 0.0.0.0/8        -j DROP
iptables -A INPUT -d 239.255.255.0/24 -j DROP
iptables -A INPUT -d 255.255.255.255  -j DROP

iptables -A INPUT -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A INPUT -m recent --name portscan --remove

iptables -A INPUT -p tcp -m tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,ACK SYN,ACK -m state --state NEW -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j LOG --log-prefix "new no syn: " --log-level 7
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s --limit-burst 1 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type network-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type host-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type protocol-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type port-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type fragmentation-needed -j DROP
iptables -A INPUT -p icmp --icmp-type source-route-failed -j ACCEPT
iptables -A INPUT -p icmp --icmp-type network-unknown -j ACCEPT
iptables -A INPUT -p icmp --icmp-type host-unknown -j ACCEPT
iptables -A INPUT -p icmp --icmp-type network-prohibited -j ACCEPT
iptables -A INPUT -p icmp --icmp-type host-prohibited -j ACCEPT
iptables -A INPUT -p icmp --icmp-type TOS-network-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type TOS-host-unreachable -j ACCEPT
iptables -A INPUT -p icmp --icmp-type communication-prohibited -j ACCEPT
iptables -A INPUT -p icmp --icmp-type host-precedence-violation -j DROP
iptables -A INPUT -p icmp --icmp-type precedence-cutoff -j DROP
iptables -A INPUT -p icmp --icmp-type source-quench -j DROP
iptables -A INPUT -p icmp --icmp-type redirect -j DROP
iptables -A INPUT -p icmp --icmp-type network-redirect -j DROP
iptables -A INPUT -p icmp --icmp-type host-redirect -j DROP
iptables -A INPUT -p icmp --icmp-type TOS-network-redirect -j DROP
iptables -A INPUT -p icmp --icmp-type TOS-host-redirect -j DROP
iptables -A INPUT -p icmp --icmp-type router-advertisement -j DROP
iptables -A INPUT -p icmp --icmp-type router-solicitation -j DROP
iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A INPUT -p icmp --icmp-type ttl-zero-during-transit -j ACCEPT
iptables -A INPUT -p icmp --icmp-type ttl-zero-during-reassembly -j ACCEPT
iptables -A INPUT -p icmp --icmp-type parameter-problem -j ACCEPT
iptables -A INPUT -p icmp --icmp-type ip-header-bad -j ACCEPT
iptables -A INPUT -p icmp --icmp-type required-option-missing -j ACCEPT
iptables -A INPUT -p icmp --icmp-type timestamp-request -j DROP
iptables -A INPUT -p icmp --icmp-type timestamp-reply -j DROP
iptables -A INPUT -p icmp --icmp-type address-mask-request -j DROP
iptables -A INPUT -p icmp --icmp-type address-mask-reply -j DROP
iptables -A INPUT -p icmp -j DROP

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED             -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 22    -j ACCEPT
#iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 80    -j ACCEPT
#iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 443   -j ACCEPT

iptables -N LOGGING
iptables -A INPUT   -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "pkt dropped: " --log-level 7
iptables -A LOGGING -j DROP
