#!/usr/bin/bash
cat /etc/hostname | xargs echo id: >> /etc/salt/minion
systemctl restart salt-minion.service

