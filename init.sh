#!/bin/sh

sudo sed -i 's/\r$//' ./zeek/install-zeek.sh
sudo sed -i 's/\r$//' ./zeek/include-hash-sha256.sh
sudo sed -i 's/\r$//' ./splunk/install-splunk.sh
sudo sed -i 's/\r$//' ./splunk/install-splunk-forwarder.sh

sudo chmod +x ./zeek/install-zeek.sh
sudo chmod +x ./zeek/include-hash-sha256.sh
sudo chmod +x ./splunk/install-splunk.sh
sudo chmod +x ./splunk/install-splunk-forwarder.sh
