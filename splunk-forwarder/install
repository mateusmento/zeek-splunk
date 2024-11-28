#!/bin/sh

# (Revisao do material) Instalar e configurar o Splunk Universal Fowarder
# Se o URL não funcionar mais: https://www.splunk.com/en\_us/download/universal-forwarder.html
sudo wget -O splunkforwarder-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/9.0.3/linux/splunkforwarder-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb"
sudo dpkg -i splunkforwarder-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb

sudo /opt/splunkforwarder/bin/splunk start --accept-license
sudo /opt/splunkforwarder/bin/splunk stop
sudo cp ./inputs.conf /opt/splunkforwarder/etc/system/local
sudo cp ./outputs.conf /opt/splunkforwarder/etc/system/local
sudo /opt/splunkforwarder/bin/splunk enable boot-start -systemd-managed 0
sudo /opt/splunkforwarder/bin/splunk start

sudo /opt/splunkforwarder/bin/splunk stop
# Editar o arquivo inputs.conf para monitorar os logs Zeek que deseja
sudo cp ./inputs.conf /opt/splunkforwarder/etc/system/local
# Edite outputs.conf para enviar dados para o servidor Splunk
sudo cp ./outputs.conf /opt/splunkforwarder/etc/system/local