#!/bin/sh

# Escolher o repositorio adequado a versao do Debian em https://software.opensuse.org/download.html?project=security%3Azeek&package=zeek-lts
sudo cat /etc/debian_version
# ATENCAO: ESSE REPOSITORIO SOH FUNCIONA NO DEBIAN 12
sudo echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
sudo curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
sudo apt -y update
sudo apt -y install zeek-lts -f
sudo setcap cap_net_raw=eip /opt/zeek/bin/zeek
sudo setcap cap_net_raw=eip /opt/zeek/bin/capstats
sudo bash -c 'echo -e "ZeekPort = 27760" >> /opt/zeek/etc/zeekctl.cfg'
export PATH=/opt/zeek/bin:$PATH
