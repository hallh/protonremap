FROM debian:bullseye-slim

# Instal stunnel for IMAP tunnel
RUN apt-get update -y && apt-get install -y stunnel wget && apt-get clean

# Fetch go-tcp-proxy
RUN cd /opt/ && \
      wget "https://github.com/jpillora/go-tcp-proxy/releases/download/v1.0.2/go-tcp-proxy_1.0.2_linux_amd64.gz" && \
      gunzip go-tcp-proxy_1.0.2_linux_amd64.gz && \
      chmod u+x go-tcp-proxy_1.0.2_linux_amd64

# Copy config and runscript
COPY ./ /opt/

# Runit
CMD /bin/bash /opt/run.sh
