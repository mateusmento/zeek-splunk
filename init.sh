#!/bin/sh

sudo sed -i 's/\r$//' ./zeek/install-zeek.sh
sudo sed -i 's/\r$//' ./zeek/include-hash-sha256.sh
sudo sed -i 's/\r$//' ./zeek/config-zeek
sudo sed -i 's/\r$//' ./zeek/config-zeek-node
sudo sed -i 's/\r$//' ./zeek/deploy-zeek
sudo sed -i 's/\r$//' ./zeek/stop-zeek
sudo sed -i 's/\r$//' ./zeek/install-zkg
sudo sed -i 's/\r$//' ./zeek/include-hash-sha256.sh
sudo sed -i 's/\r$//' ./splunk/install-splunk.sh
sudo sed -i 's/\r$//' ./splunk/install-splunk-forwarder.sh

sudo chmod +x ./zeek/install-zeek.sh
sudo chmod +x ./zeek/include-hash-sha256.sh
sudo chmod +x ./zeek/config-zeek
sudo chmod +x ./zeek/config-zeek-node
sudo chmod +x ./zeek/deploy-zeek
sudo chmod +x ./zeek/stop-zeek
sudo chmod +x ./zeek/install-zkg
sudo chmod +x ./splunk/install-splunk.sh
sudo chmod +x ./splunk/install-splunk-forwarder.sh
