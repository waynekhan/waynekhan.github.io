---
layout: default
title: (Digital) Certificate Management
---

## (Digital) Certificate Management

Previously, I wrote a blog post about [using the OpenSSL CLI tool to generate digital certificates](/2019/08/01/openssl-x509.html). Since then, I've refined things a bit on my end, and here's the update, please consider the old post deprecated.

First of all, we'll need a private key file; e.g., `privkey.pem`:

```text
openssl genrsa -out privkey.pem 2048
```

From the private key, we'll generate a new CSR - Certificate Signing Request file; e.g., `signme.csr`:

```text
openssl req -new -sha256 -days 90 -key privkey.pem -out signme.csr
```

With both the private key and CSR files on hand, we'll [verify if the checksums match](https://www.ssl247.com/kb/ssl-certificates/troubleshooting/certificate-matches-private-key); e.g.,

```text
$ openssl rsa -noout -modulus -in privkey.pem | openssl md5
(stdin)= 8b070aeae88fb16b3b815e4830223505
$ openssl req -noout -modulus -in signme.csr | openssl md5
(stdin)= 8b070aeae88fb16b3b815e4830223505
```

Now we'll submit the CSR to our CA; once the certificate is issued, also verify that its checksum matches; e.g., `certalone.pem`:

```text
$ openssl x509 -noout -modulus -in certalone.pem | openssl md5
(stdin)= 8b070aeae88fb16b3b815e4830223505
```

NB: The above is for the __single issued certificate only, without any intermediate/root certificates__.

[Concatenate the certificate, plus any intermediate/root certificates](https://medium.com/@superseb/get-your-certificate-chain-right-4b117a9c0fce); e.g., `fullchain.pem`:

```text
cat certalone.pem interm.pem > fullchain.pem
```

Subsequently, use `privkey.pem` and `fullchain.pem` in your web server config.

