#!/bin/bash

# Eliminando mensagem "Disk space on /opt/splunk below the minimum of 5000MB"
cp /opt/splunk/etc/system/local/server.conf /opt/splunk/etc/system/local/server.conf.old
cp /curso/aula2/server.txt /opt/splunk/etc/system/local
server_conf_file="/opt/splunk/etc/system/local/server.conf" # Define o caminho do arquivo de destino
config_content_file="/opt/splunk/etc/system/local/server.txt" # Define o caminho do arquivo de origem com o conteúdo a ser copiado
echo -e "\n$(cat $config_content_file)" >> $server_conf_file # Adiciona uma linha vazia e, em seguida, o conteúdo do arquivo de origem ao final do arquivo de destino
/opt/splunk/bin/splunk restart