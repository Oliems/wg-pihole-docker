#!/bin/bash

docker stop wg-easy && \
docker rm wg-easy && \
docker pull weejewel/wg-easy && \
docker run -d \
  --name=wg-easy \
  -e WG_HOST=199.247.12.9 \
  -e PASSWORD=nDWuUylpKJ5fRwgiT9NCfND6ZMIAIaxf \
  -e WG_DEFAULT_DNS=172.17.0.3 \
  -v ~/wg-easy:/etc/wireguard \
  -p 51820:51820/udp \
  -p 51821:51821/tcp \
  --ip 172.17.0.2 \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --restart unless-stopped \
  weejewel/wg-easy