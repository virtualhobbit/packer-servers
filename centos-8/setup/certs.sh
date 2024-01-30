#!/bin/sh

export WEBSERVER="intranet.mdb-lab.com"
export URL="http://"$WEBSERVER
export CERTROOT="rootCA.crt"
export CERTISSUING="issuingCA2.crt"

cd /etc/pki/ca-trust/source/anchors

# Download Root CA certificate
/usr/bin/curl -k -O "$URL/$CERTROOT"

# Download Issuing CA certificate
/usr/bin/curl -k -O "$URL/$CERTISSUING"

# Update the CA bundle
/usr/bin/update-ca-trust extract