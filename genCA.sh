#!/bin/sh
OUTPUT_DIR=cafiles

if [ -d $OUTPUT_DIR ]; then
  echo "Detected old output directory, moving to $OUTPUT_DIR.old"
  mv $OUTPUT_DIR $OUTPUT_DIR.old
fi

mkdir $OUTPUT_DIR
pushd $OUTPUT_DIR
mkdir certs crl newcerts private
chmod 700 private
touch index.txt index.txt.attr
echo 1000 > serial

openssl genrsa -aes256 -out private/ca.key.pem 4096

openssl req -config ../ssl.cnf -key private/ca.key.pem -new -x509 -days 999 -sha256 -extensions v3_ca -out certs/ca.cert.pem

chmod 400 private/ca.key.pem

popd
