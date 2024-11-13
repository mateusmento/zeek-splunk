sudo apt-get -y update


# >>Util

sudo apt -y install gedit
sudo pip install setuptools --break-system-packages
sudo pip install python-whois --break-system-packages
sudo apt-get -y install curl
sudo apt-get -y install wget
sudo apt -y install dnsutils
sudo apt-get install zip


# >>Instalar Splunk

# Copie MANUALMENTE os arquivos do diretório "Grupo 8" do Windows para o diretório "/tcc/grupo8/" na VM Linux
sudo mkdir -p /tcc/grupo8/
sudo chmod 744 /tcc/grupo8/*.sh
cp /tcc/grupo8/*.sh /opt
cp /tcc/grupo8/*.sh /opt
sudo chmod 744 /opt/*.sh

cd /opt

# Instalar Splunk
sudo apt-get -y install rsyslog
sudo wget -O splunk-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb https://download.splunk.com/products/splunk/releases/9.0.3/linux/splunk-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb
sudo dpkg -i splunk-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb
sudo adduser splunk
sudo groupadd splunk
sudo /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd splunk123
sudo touch /opt/splunk/etc/system/local/user-seed.conf
sudo bash -c 'echo -e "[user_info]\nUSERNAME = admin\nPASSWORD = splunk123" > /opt/splunk/etc/system/local/user-seed.conf' # Sobrescreve o conteudo do arquivo
sudo /opt/splunk/bin/splunk enable boot-start
sudo chown -R splunk:splunk /opt/splunk

# Eliminando mensagem "Disk space on /opt/splunk below the minimum of 5000MB"
sudo su
cp /opt/splunk/etc/system/local/server.conf /opt/splunk/etc/system/local/server.conf.old
cp /tcc/grupo8/server.txt /opt/splunk/etc/system/local
server_conf_file="/opt/splunk/etc/system/local/server.conf" # Define o caminho do arquivo de destino
config_content_file="/opt/splunk/etc/system/local/server.txt" # Define o caminho do arquivo de origem com o conteúdo a ser copiado
echo -e "\n$(cat $config_content_file)" >> $server_conf_file # Adiciona uma linha vazia e, em seguida, o conteúdo do arquivo de origem ao final do arquivo de destino
exit
sudo /opt/splunk/bin/splunk restart

# Desinstalar Splunk
#/opt/splunk/bin/splunk disable boot-start
#/opt/splunk/bin/splunk stop
#/opt/splunkforwarder/bin/splunk stop
#PIDS=$(ps -ef | grep splunk | grep -v grep | awk '{print $2}')
#if [ -z "$PIDS" ]; then
#  echo "Nenhum processo splunk encontrado."
#else
#  echo "Matando processos: $PIDS"
#  kill -9 $PIDS
#  sleep 1  # Adiciona um pequeno intervalo para garantir o término
#fi
#dpkg -r splunk
#rm -rf /opt/splunk
#userdel splunk
#groupdel splunk


# >>Instalar Zeek
cd /opt
# Escolher o repositorio adequado a versao do Debian em https://software.opensuse.org/download.html?project=security%3Azeek&package=zeek-lts
sudo cat /etc/debian_version
# ATENCAO: ESSE REPOSITORIO SOH FUNCIONA NO DEBIAN 12
sudo echo 'deb http://download.opensuse.org/repositories/security:/zeek/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
sudo curl -fsSL https://download.opensuse.org/repositories/security:zeek/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
sudo apt -y update
sudo apt -y install zeek-lts
sudo setcap cap_net_raw=eip /opt/zeek/bin/zeek
sudo setcap cap_net_raw=eip /opt/zeek/bin/capstats
sudo bash -c 'echo -e "ZeekPort = 27760" >> /opt/zeek/etc/zeekctl.cfg'
export PATH=/opt/zeek/bin:$PATH


# Copie MANUALMENTE os arquivos do diretório "Grupo 8" do Windows para o diretório "/tcc/grupo8/" na VM Linux
sudo mkdir /tcc/grupo8/
sudo /opt/zeek/bin/zeekctl stop
cp /opt/zeek/etc/node.cfg /opt/zeek/etc/node.cfg.old
rm /opt/zeek/etc/node.cfg
cp /tcc/grupo8/node.cfg /opt/zeek/etc/ # Interface AWS
chmod 664 /opt/zeek/etc/node.cfg
chown root:zeek /opt/zeek/etc/node.cfg # Dono root, grupo zeek

active_interface=$(ip route | grep default | awk '{print $5}') # Encontra a interface de rede ativa
config_file="/opt/zeek/etc/node.cfg" # Define o caminho do arquivo de configuração
sudo sed -i "s/interface=.*/interface=$active_interface/g" $config_file # Substitui todas as ocorrências de "interface=" pelo valor da interface ativa
echo -e "\ninterface=$active_interface" | sudo tee -a /opt/zeek/etc/node.cfg

# Gerenciador de pacotes 'zkg'
cd /opt
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

# Copie MANUALMENTE os arquivos do diretório "Grupo 8" do Windows para o diretório "/tcc/grupo8/" na VM Linux
sudo mkdir /tcc/grupo8/
# Transformar os logs do Zeek para JSON
sudo /opt/zeek/bin/zeekctl stop
sudo cp /opt/zeek/share/zeek/site/local.zeek /opt/zeek/share/zeek/site/local.zeek.old
sudo rm /opt/zeek/share/zeek/site/local.zeek
sudo cp /tcc/grupo8/local.zeek /opt/zeek/share/zeek/site
sudo chmod 664 /opt/zeek/share/zeek/site/local.zeek
sudo chown root:zeek /opt/zeek/share/zeek/site/local.zeek # Dono root, grupo zeek
sudo /opt/zeek/bin/zeekctl deploy

# (Revisao do material) Instalar e configurar o Splunk Universal Fowarder
# Se o URL não funcionar mais: https://www.splunk.com/en\_us/download/universal-forwarder.html
cd /opt
sudo wget -O splunkforwarder-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/9.0.3/linux/splunkforwarder-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb"
sudo dpkg -i splunkforwarder-9.0.3-dd0128b1f8cd-linux-2.6-amd64.deb

sudo /opt/splunkforwarder/bin/splunk start --accept-license
sudo /opt/splunkforwarder/bin/splunk stop
sudo cp /opt/grupo9/inputs.conf /opt/splunkforwarder/etc/system/local
sudo cp /opt/grupo9/outputs.conf /opt/splunkforwarder/etc/system/local
sudo /opt/splunkforwarder/bin/splunk enable boot-start -systemd-managed 0
sudo /opt/splunkforwarder/bin/splunk start

sudo /opt/splunkforwarder/bin/splunk stop
# Editar o arquivo inputs.conf para monitorar os logs Zeek que deseja
sudo cp /tcc/grupo8/inputs.conf /opt/splunkforwarder/etc/system/local
# Edite outputs.conf para enviar dados para o servidor Splunk
sudo cp /tcc/grupo8/outputs.conf /opt/splunkforwarder/etc/system/local