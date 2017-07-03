#!/usr/bin/bash
network={{ NETWORK }}
grep -w `ip addr | grep $network | grep inet | awk '{print $2}' | awk -F '/' '{print $1}'` /etc/hosts | awk '{print $2}' | xargs hostnamectl --static set-hostname
