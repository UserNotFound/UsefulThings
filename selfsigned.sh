#!/usr/bin/env bash
#set -x

# get the domain from the command line
domain=$1

# Specify where we will place the certificate
ssldir="./${domain}"
csr="${ssldir}/${domain}.csr"
key="${ssldir}/${domain}.key"
crt="${ssldir}/${domain}.crt"
pem="${ssldir}/${domain}.pem"


# Make it a wildcard
wild_domain="*.${domain}"

# A blank passphrase, or one provided on command line
PASSPHRASE="$2"

# Set our CSR variables
SUBJ="
C=US
ST=Indiana
O=FTPHosting
localityName=Indianpolis
commonName=${wild_domain}
organizationalUnitName=
emailAddress=
"

# Create our SSL directory
# in case it doesn't exist
sudo mkdir -p "$ssldir"

# Generate our Private Key, CSR and Certificate
sudo openssl genrsa -out "${key}" 2048
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "${key}" -out "${csr}" -passin pass:$PASSPHRASE
sudo openssl x509 -req -days 365 -in "${csr}" -signkey "${key}" -out "${crt}"

# Edit permissions
sudo chown `id -u`:`id -g` -R ${ssldir}

# Generate .pem file
cat ${crt} ${key} >> ${pem}
