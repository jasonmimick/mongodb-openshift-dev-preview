FROM debian:jessie-slim

EXPOSE 8080

RUN apt-get -qq update && apt-get -y -qq install apt-utils

RUN apt-get -y -qq install iputils-ping libsasl2-2 net-tools curl supervisor jq \
    && rm -rf /var/lib/apt/lists/*

COPY content/ /mongodb-mms/
COPY content/mongod.conf /etc/security/limits.d/
RUN groupadd -r mongod && useradd -r -g mongod mongod

#startup command found in yaml
#CMD supervisord -c /mongodb-mms/supervisor.conf

# To build: docker build . -t om-on-k8s

# To run normally (should specify env variables first):
# docker run -it om-on-k8s
