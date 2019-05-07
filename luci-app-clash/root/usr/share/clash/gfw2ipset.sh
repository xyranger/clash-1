#!/bin/sh

pdnsd_port=$(uci get clash.config.dns_server |awk -F '#' '{print $2}' 2>/dev/null)
awk '!/^$/&&!/^#/{printf("ipset=/.%s/'"gfwlist"'\n",$0)}' /etc/config/clash_gfw.list > /etc/clash/custom_forward.conf
awk '!/^$/&&!/^#/{printf("server=/.%s/'"127.0.0.1#$pdnsd_port"'\n",$0)}' /etc/config/clash_gfw.list >> /etc/clash/custom_forward.conf

