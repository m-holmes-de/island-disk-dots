#!/usr/bin/env bash
#A simple script using the xremap project

# TODO: change to curl to get exact file
# https://github.com/k0kubun/xremap
# Download the hypr.zip from releases

# TODO: unzip binary and then copy to /usr/bin

# TODO: Copy the xremap-service to correct location
# Copy the xremap.service into the /etc/systemd/system/xremap.service

systemctl daemon-reload
systemctl enable xremap.service
systemctl restart xremap.service

