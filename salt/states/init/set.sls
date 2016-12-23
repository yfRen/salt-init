sethosts:
  file.managed:
    - source: salt://init/file/hosts
    - name: /etc/hosts
    - user: root
    - group: root
    - mode: 644

setresolv:
  file.managed:
    - source: salt://init/file/resolv.conf
    - name: /etc/resolv.conf
    - user: root
    - group: root
    - mode: 644
  
setfirewall:
  cmd.run:
    - name: setenforce 0 && sed -i  "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config && systemctl stop firewalld.service && iptables --flush && systemctl disable firewalld.service
  pkg.installed:
    - names:
      - iptables-services  
  file.managed:
    - source: salt://init/file/iptables
    - name: /etc/sysconfig/iptables 
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: setfirewall
 
installminion:
  cmd.run:
    - name: yum -y install epel* && yum -y install salt-minion  && yum -y remove net-tools && yum -y install net-tools
  file.managed:
    - source: salt://init/file/minion
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 644
    - require: 
      - cmd: installminion

hostname-set:
  file.managed:
    - source: salt://init/file/hostnameset.sh
    - name: /tmp/hostnameset.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: bash /tmp/hostnameset.sh
    - require:
      - file: hostname-set

minion-running:
 service.running:
    - name: salt-minion
    - enable: True
    - require: 
      - file: installminion

changepasswd:
  cmd.run:
    - name: "echo '123456' | passwd --stdin root && touch /tmp/changepasswd.lock"
    - unless: test -f /tmp/changepasswd.lock
 
 
