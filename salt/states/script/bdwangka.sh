#!/usr/bin/bash
#from sunshouhui
#绑定光口3和4
#获取172网卡的最后一位
ip=$(ifconfig | grep "172.16.0" | awk '{print $2}' | sed 's/172.16.0/192.168.0/')
echo $ip
#1.创建一个组接口
nmcli connection add type team con-name team2 ifname team2 config '{"runner":{"name":"loadbalance"}}'
#
#2.添加从设备
nmcli connection add type team-slave con-name team2-port1 ifname enp5s0f0 master team2
nmcli connection add type team-slave con-name team2-port2 ifname enp5s0f1 master team2 
#
#3.非配ip地址
nmcli connection modify team2 ipv4.addresses $ip/24
#
#4.分配网关
nmcli connection modify team2 ipv4.gateway 192.168.0.254
#
#5.分配DNS
nmcli connection modify team2 ipv4.dns 8.8.8.8
#
#6.执行手动模式
nmcli connection modify team2 ipv4.method manual
#
#
#7.启动组接口
#
nmcli connection up team2






