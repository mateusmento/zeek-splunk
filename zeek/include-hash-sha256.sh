#!/bin/sh
cp ./hash_sha256.zeek /opt/zeek/share/zeek/site/hash_sha256.zeek
echo "@load hash_sha256" >> /opt/zeek/share/zeek/site/local.zeek
