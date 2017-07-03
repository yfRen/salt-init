set-hosts:
  file.managed:
    - source: salt://init/file/hosts
    - name: /etc/hosts
    - user: root
    - group: root
    - mode: 644

set-resolv:
  file.managed:
    - source: salt://init/file/resolv.conf
    - name: /etc/resolv.conf
    - user: root
    - group: root
    - mode: 644
  
set-firewall:
  cmd.run:
    - name: setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config && systemctl stop firewalld.service && iptables --flush && systemctl disable firewalld.service
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
      - pkg: set-firewall
 
install-ntp:
  pkg.installed:
    - names:
      - ntp
  service.running:
    - name: ntpd
    - enable: True

install-minion:
  pkg.installed:
    - names:
      - epel-release
      - salt-minion
      - net-tools
      - vim-enhanced
  file.managed:
    - source: salt://init/file/minion
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 644
    - require: 
      - pkg: install-minion

hostname-set:
  file.managed:
    - source: salt://init/file/hostnameset.sh
    - name: /tmp/hostnameset.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - default:
      NETWORK: enp3s0f0 
  cmd.run:
    - name: bash /tmp/hostnameset.sh
    - require:
      - file: hostname-set

minion-running:
  service.running:
    - name: salt-minion
    - enable: True
    - require: 
      - file: install-minion

change-passwd:
  cmd.run:
    - name: "echo 'JPHRcjy@1233' | passwd --stdin root && touch /tmp/changepasswd.lock"
    - unless: test -f /tmp/changepasswd.lock
