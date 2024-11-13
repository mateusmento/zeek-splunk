#!/bin/sh
sudo cp ./hash_sha256.zeek /opt/zeek/share/zeek/site/hash_sha256.zeek
sudo echo "@load hash_sha256" >> /opt/zeek/share/zeek/site/local.zeek
