#!/bin/bash

# Desinstalar Splunk
dpkg -r splunk
rm -rf /opt/splunk
userdel splunk
groupdel splunk