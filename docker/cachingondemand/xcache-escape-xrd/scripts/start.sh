#! /bin/bash

if [ ! -f /etc/grid-security/certificates/DODAS.pem ]; then

    /usr/local/bin/dodas-x509 --hostname $XRD_HOST --gen-certs --ca-path /etc/grid-security/certificates --cert-path /etc/grid-security --ca-name DODAS
    for i in `openssl x509 -in /etc/grid-security/certificates/DODAS.pem -subject_hash`; do
        ln -s /etc/grid-security/certificates/DODAS.pem /etc/grid-security/certificates/$i.0
        break
    done

fi

if [ ! -f /etc/grid-security/hostcert.pem ]; then
    /usr/local/bin/dodas-x509 --hostname $XRD_HOST --ca-path /etc/grid-security/certificates --cert-path /etc/grid-security --ca-name DODAS
    for i in `openssl x509 -in /etc/grid-security/certificates/DODAS.pem -subject_hash`; do
        ln -s /etc/grid-security/certificates/DODAS.pem /etc/grid-security/certificates/$i.0
        break
    done

    chown -R xrootd: /etc/grid-security/hostcert.pem /etc/grid-security/hostcert.key
fi

sudo -E -u xrootd /usr/bin/xrootd -k 3 -l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-escape.cfg -n escape &

sleep infinity