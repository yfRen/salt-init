#!/usr/bin/bash
#查看哪些主机缺少在线网卡
#from sunshouhui
#ip a | grep -w "state UP" | grep -v "enp3s0f0"
ip=`ifconfig | grep "172.16.0" | awk '{print $2}'`
ip a | grep -w "state UP" | grep -v "enp3s0f0" | wc -l | xargs echo "$ip gkou:"
