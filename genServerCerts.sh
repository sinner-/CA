#!/bin/sh

NODE=$1
if ! [ $NODE ]; then
  echo NODE not set.
  exit 1
fi

mkdir -p nodes

if [ -d nodes/$NODE ]; then
  echo "Old nodes directory for this $NODE detected, moving to $NODE.old"
  mv nodes/$NODE nodes/$NODE.old
fi

mkdir nodes/$NODE

#No password
openssl genrsa -out nodes/$NODE/$NODE.key.pem 2048
#Password
#openssl genrsa -aes256 -out nodes/$NODE/$NODE.key.pem 2048
chmod 400 nodes/$NODE/$NODE.key.pem

EXTENSION="usr_cert"
if [ $NODE == "openvpn" ]; then
  openvpn --genkey tls-crypt nodes/$NODE/tls-crypt.pem
  openssl dhparam -out nodes/$NODE/$NODE.dh2048.pem 2048
  EXTENSION="server_cert"
fi

openssl req -config ssl.cnf -key nodes/$NODE/$NODE.key.pem -new -sha256 -out nodes/$NODE/$NODE.csr.pem

pushd cafiles
openssl ca -config ../ssl.cnf -extensions $EXTENSION -days 999 -notext -md sha256 -in ../nodes/$NODE/$NODE.csr.pem -out ../nodes/$NODE/$NODE.cert.pem
popd
