#!/bin/bash

# Instalar Splunk
apt-get -y install rsyslog
wget -O splunk-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb https://download.splunk.com/products/splunk/releases/9.0.3/linux/splunk-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb
dpkg -i splunk-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb
adduser splunk
groupadd splunk
/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd splunk123
touch /opt/splunk/etc/system/local/user-seed.conf
bash -c 'echo -e "[user_info]\nUSERNAME = admin\nPASSWORD = splunk123" > /opt/splunk/etc/system/local/user-seed.conf' # Sobrescreve o conteudo do arquivo
/opt/splunk/bin/splunk enable boot-start
chown -R splunk:splunk /opt/splunk