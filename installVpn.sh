#!/bin/sh

sudo apt update \
	&& sudo apt upgrade -y \
	&& sudo apt install docker.io docker-compose -y

mkdir -p ~/wireguard/config

cat << EOF > ~/wireguard/docker-compose.yml
---
version: "2.1"
services:
  wireguard:
    image: lscr.io/linuxserver/wireguard
    container_name: wireguard
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - SERVERURL=auto #optional
      - SERVERPORT=51820 #optional
      - PEERS=10 #optional
      - PEERDNS=auto #optional
      - INTERNAL_SUBNET=10.13.13.0 #optional
      - ALLOWEDIPS=0.0.0.0/0 #optional
    volumes:
      - ~/wireguard/config:/config
      - /lib/modules:/lib/modules
    ports:
      - 51820:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped
EOF

docker-compose -f ~/wireguard/docker-compose.yml up -d

docker ps
