#!/bin/sh

instance=$1

echo "LB instance: ${instance}"

apt-get update -y
apt-get install -y haproxy keepalived tcpdump socat

sysctl net.ipv4.ip_nonlocal_bind | grep 1
if [ $? -ne 0 ]; then
  sysctl -w net.ipv4.ip_nonlocal_bind=1
  echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf
fi

ip add show eth1

# keepalived setup
cp "/vagrant/lb${instance}-keepalived.conf" /etc/keepalived/keepalived.conf
service keepalived restart

# HAProxy setup
cp "/vagrant/lb${instance}-haproxy.cfg" /etc/haproxy/haproxy.cfg
cp /vagrant/haproxy-defaults /etc/default/haproxy
service haproxy restart
