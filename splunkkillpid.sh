#!/bin/bash

# Matar processos
/opt/splunk/bin/splunk disable boot-start
/opt/splunk/bin/splunk stop

PIDS=$(ps -ef | grep splunk | grep -v grep | awk '{print $2}')
if [ -z "$PIDS" ]; then
  echo "Nenhum processo splunk encontrado."
else
  echo "Matando processos: $PIDS"
  kill -9 $PIDS
  sleep 1  # Adiciona um pequeno intervalo para garantir o término
fi