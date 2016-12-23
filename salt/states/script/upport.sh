#!/usr/bin/bash
ip=`ifconfig | grep "172.16.0" | awk '{print $2}'`
teamnl team2 ports | wc -l | xargs echo $ip "up:" 
