FROM ubuntu:16.04

ENV http_proxy=http://172.19.0.1:3128
ENV https_proxy=http://172.19.0.1:3128
#Configura certificado do Big Broder Sicoob, assim e possivel acesso a rede de dentro do container
#Obs: configure uma rede em modo bridge e passea como parametro no docker build
ADD deb/libssl1.1_1.1.0f-3_amd64.deb /tmp/libssl1.1_1.1.0f-3_amd64.deb
ADD deb/openssl_1.1.0f-3_amd64.deb /tmp/openssl_1.1.0f-3_amd64.deb
ADD deb/ca-certificates_20161130+nmu1_all.deb /tmp/ca-certificates_20161130+nmu1_all.deb
RUN dpkg -i /tmp/libssl1.1_1.1.0f-3_amd64.deb
RUN dpkg -i /tmp/openssl_1.1.0f-3_amd64.deb
RUN dpkg -i /tmp/ca-certificates_20161130+nmu1_all.deb
ADD wasp101.64.crt /usr/share/ca-certificates/
RUN echo "wasp101.64.crt" >> /etc/ca-certificates.conf
RUN update-ca-certificates

## Necessario haver CNTLM no Host configurado para receber requsicoes de qualquer computador 0.0.0.0 e configurado na porta 3128
ADD apt.conf /etc/apt/
RUN apt-get upgrade -y
RUN apt-get update && apt-get install -y vim tmux net-tools iputils-* apt-utils curl

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
RUN npm config set https-proxy $http_proxy
RUN npm config set proxy $http_proxy
RUN npm config set cafile=/usr/share/ca-certificates/wasp101.64.crt
