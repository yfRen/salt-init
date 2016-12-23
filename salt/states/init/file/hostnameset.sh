#!/usr/bin/bash
ip=`ifconfig | grep "10.0.1" | awk '{print $2}'`
grep -w "$ip" /etc/hosts | awk '{print $2}' | xargs echo > /etc/hostname 
