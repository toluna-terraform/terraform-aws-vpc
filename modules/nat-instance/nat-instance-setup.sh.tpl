#!/bin/bash
yum update -y
sysctl -w net.ipv4.ip_forward=1
/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
yum install iptables-services -y
/sbin/iptables-save > /etc/sysconfig/iptables
systemctl enable iptables
systemctl start iptables
# Adding cron for security updates.
yum install yum-cron -y
# By default "update_cmd" is default which means cron runs yum upgrade -y.
sed -i "s/update_cmd = default/update_cmd = security/" /etc/yum/yum-cron.conf
sed -i "s/apply_updates = no/apply_updates = yes/" /etc/yum/yum-cron.conf
systemctl enable yum-cron
systemctl start yum-cron