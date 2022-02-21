#!/bin/sh


echo "修改更新源"
wget -P /etc/apt -N https://gitee.com/sw586/wky/raw/master/sources.list
wget -P /etc/apt/sources.list.d -N https://gitee.com/sw586/wky/raw/master/armbian.list
echo "下载DNS更新脚本"
wget -P /root -N https://gitee.com/sw586/wky/raw/master/dns_c-j.52jsm.com.sh
wget -P /root -N https://gitee.com/sw586/wky/raw/master/dns_wky.52jsm.com.sh
echo "防错执行"
touch /etc/apt/apt.conf.d/99verify-peer.conf
echo >>/etc/apt/apt.conf.d/99verify-peer.conf "Acquire { https::Verify-Peer false }"
apt update
apt upgrade
echo "搭建x"
wget -P /root -N https://gitee.com/sw586/wky/raw/master/x.zip
mv /root/x.jpg /root/x.zip
unzip /root/x.zip

echo "设置权限"
chmod u+x /root/dns_c-j.52jsm.com.sh
chmod u+x /root/dns_wky.52jsm.com.sh
chmod u+x /root/xray/run.sh
chmod u+x /root/xray/xray

echo "设置X开机启动"
sed -i '/exit 0/i /root/xray/run.sh' /etc/rc.local
