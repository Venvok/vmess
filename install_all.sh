#!/bin/bash

wget https://raw.githubusercontent.com/Venvok/vmess/main/setup.sh -O setup.sh && chmod +x setup.sh && ./setup.sh && \
wget https://raw.githubusercontent.com/Venvok/vmess/main/backup.sh -O backup.sh && chmod +x backup.sh && ./backup.sh && \
wget https://raw.githubusercontent.com/Venvok/vmess/main/xp.sh -O xp.sh && chmod +x xp.sh && ./xp.sh && \
wget https://raw.githubusercontent.com/Venvok/vmess/main/config.json -O config.json && \
wget https://raw.githubusercontent.com/Venvok/vmess/main/nginx.conf -O /etc/nginx/nginx.conf
