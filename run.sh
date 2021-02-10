#!/bin/bash

# Workdir
cd /opt/

# Run IMAP tunnel
stunnel /opt/stunnel.conf

nohup /opt/go-tcp-proxy_1.0.2_linux_amd64 \
      -l localhost:2144 \
      -r localhost:2143 \
      -replace '(.\d+) UID (SEARCH.*) NOT DELETED~$1 UID $2 UNDELETED' 2>&1 >> /tmp/goprx.log &

nohup /opt/go-tcp-proxy_1.0.2_linux_amd64 \
      -l localhost:3143 \
      -r localhost:2144 \
      -replace '(.\d+) UID FETCH (\d+) BODY\.PEEK\[1\]~$1 UID FETCH $2 BODY[text]' 2>&1 >> /tmp/goprx.log &

tail -f /tmp/goprx.log
