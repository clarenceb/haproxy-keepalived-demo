#!/bin/sh

instance=$1

apt-get update -y
apt-get install -y haproxy keepalived tcpdump

cp "/vagrant/lb${instance}-haproxy.cfg /etc/haproxy/haproxy.cfg
cp /vagrant/keepalived.conf /etc/keepalived/keepalived.conf
cp /vagrant/haproxy-defaults /etc/defaults/haproxy

service haproxy restart
service keepalived restart

