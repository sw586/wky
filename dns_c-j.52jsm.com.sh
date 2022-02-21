#!/bin/bash
auth_email="cf@ucziyuan.com"
auth_key="bffa909288659683bcacdceee93e2e7bb9be4"
zone_id="2b7b354dd85c4211f265fd5fdb7b0c88"
dns_id="1c64f3ce5849687f9576e0a103b0fc07"
domain_name="c-j.52jsm.com"

eth_card="eth0"
ip_file="/sd/wwwroot/dnslog/wky.52jsm.com.txt"

#New_IP6=$(curl -6 ip.sb)
#New_IP6=$(curl -s 'https://api6.ipify.org')
#以上是网络方式获取最新IPv6地址

#New_IP6=`ip -6 addr show dev $eth_card | grep global | awk '{ print $2}' | awk -F "/" '{print $1}' | head -1`
New_IP6=`ip addr show $eth_card | grep -v deprecated | grep -A1 'inet6 [^f:]' |grep -v ^-- |sed -nr ':a;N;s#^ +inet6 ([a-f0-9:]+)/.+? scope global .*? valid_lft ([0-9]+sec) .*#\2 \1#p;Ta' | sort -nr | head -n1 | cut -d' ' -f2`
#以上是本地方式获取最新IPv6地址

Old_IP6=$(cat $ip_file)

if [ $New_IP6 == $Old_IP6 ]; then
    echo "IP has not changed."
    exit 0
fi

update_dns=$(curl -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$dns_id"\
    -H "X-Auth-Email: $auth_email" \
    -H "X-Auth-Key: $auth_key" \
    -H "Content-Type: application/json" \
    --data '{"type":"AAAA","name":"'"$domain_name"'","content":"'"$New_IP6"'","ttl":1,"proxied":false}')

if [[ $update_dns == *"\"success\":true"* ]]; then
    echo "DNS Update to '$New_IP6' Successfully."
    echo "$New_IP6" > $ip_file
else
    echo "Something wrong. Please check the message:"
    echo $update_dns
    exit 1
fi