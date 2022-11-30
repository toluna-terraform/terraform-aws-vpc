#!/bin/bash
NAT_INSTANCE_CONFIG="#!/bin/bash
set -x
# wait for eth0
while ! ip link show dev eth0; do
  sleep 1
done
sysctl -q -w net.ipv4.ip_forward=1
sysctl -q -w net.ipv4.conf.eth0.send_redirects=0
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
systemctl restart amazon-ssm-agent.service"

NAT_SERVICE_CONFIG="[Unit]
Description = Nat-instance service

[Service]
ExecStart = /opt/nat/nat-instance.sh
Type = oneshot

[Install]
WantedBy = multi-user.target"

mkdir -p /opt/nat
echo "$NAT_INSTANCE_CONFIG" >> /opt/nat/nat-instance.sh
chmod 0755 /opt/nat/nat-instance.sh
echo "$NAT_SERVICE_CONFIG" >> /etc/systemd/system/nat-instance.service
systemctl enable nat-instance
systemctl start nat-instance

yum update -y
# yum install iptables-services -y
# /sbin/iptables-save > /etc/sysconfig/iptables
# systemctl enable iptables
# systemctl start iptables
# Adding cron for security updates.
yum install yum-cron -y
# By default "update_cmd" is default which means cron runs yum upgrade -y.
sed -i "s/update_cmd = default/update_cmd = security/" /etc/yum/yum-cron.conf
sed -i "s/apply_updates = no/apply_updates = yes/" /etc/yum/yum-cron.conf
systemctl enable yum-cron
systemctl start yum-cron