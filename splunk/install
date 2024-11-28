#!/bin/sh

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
cp ./server.txt /opt/splunk/etc/system/local
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
