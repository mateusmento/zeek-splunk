#!/bin/sh

# >>Instalar Zeek

# Escolher o repositorio adequado a versao do Debian em https://software.opensuse.org/download.html?project=security%3Azeek&package=zeek-lts
sudo cat /etc/debian_version
# ATENCAO: ESSE REPOSITORIO SOH FUNCIONA NO DEBIAN 12
sudo echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
sudo curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
sudo apt -y update
sudo apt -y install zeek-lts
sudo setcap cap_net_raw=eip /opt/zeek/bin/zeek
sudo setcap cap_net_raw=eip /opt/zeek/bin/capstats
sudo bash -c 'echo -e "ZeekPort = 27760" >> /opt/zeek/etc/zeekctl.cfg'
export PATH=/opt/zeek/bin:$PATH

sudo /opt/zeek/bin/zeekctl stop
cp /opt/zeek/etc/node.cfg /opt/zeek/etc/node.cfg.old
rm /opt/zeek/etc/node.cfg
cp ./node.cfg /opt/zeek/etc/ # Interface AWS
chmod 664 /opt/zeek/etc/node.cfg
chown root:zeek /opt/zeek/etc/node.cfg # Dono root, grupo zeek

active_interface=$(ip route | grep default | awk '{print $5}') # Encontra a interface de rede ativa
config_file="/opt/zeek/etc/node.cfg" # Define o caminho do arquivo de configuração
sudo sed -i "s/interface=.*/interface=$active_interface/g" $config_file # Substitui todas as ocorrências de "interface=" pelo valor da interface ativa
echo -e "\ninterface=$active_interface" | sudo tee -a /opt/zeek/etc/node.cfg

# Gerenciador de pacotes 'zkg'
sudo pip config set global.break-system-packages True
sudo pip3 install GitPython semantic-version --user
sudo /opt/zeek/bin/zkg autoconfig 
sudo /opt/zeek/bin/zkg refresh
sudo /opt/zeek/bin/zkg upgrade
sudo /opt/zeek/bin/zkg install --force zeek/hosom/file-extraction
sudo /opt/zeek/bin/zkg load zeek/hosom/file-extraction
sudo /opt/zeek/bin/zeekctl deploy

#Desinstalar Zeek
#rm -rf /opt/zeek/

# >>Integrar Zeek com Splunk

# Transformar os logs do Zeek para JSON
sudo /opt/zeek/bin/zeekctl stop
sudo cp /opt/zeek/share/zeek/site/local.zeek /opt/zeek/share/zeek/site/local.zeek.old
sudo rm /opt/zeek/share/zeek/site/local.zeek
sudo cp ./local.zeek /opt/zeek/share/zeek/site
sudo chmod 664 /opt/zeek/share/zeek/site/local.zeek
sudo chown root:zeek /opt/zeek/share/zeek/site/local.zeek # Dono root, grupo zeek
sudo /opt/zeek/bin/zeekctl deploy
