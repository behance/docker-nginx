# HTTPS usage

To enable this container to serve HTTPS over its primary exposed port:
- `SERVER_ENABLE_HTTPS` environment variable must be `true`
- Certificates must be present in `/etc/nginx/certs` under the following names:
    - `ca.crt`
    - `ca.key`
- Additionally, they must be marked read-only (0600)

## Local development usage

To generate a self-signed certificate (won't work in most browsers):
```
openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -out ca.csr -subj '/CN=localhost'
openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt
mkdir -p certs/
cp ca.* certs/
```

Run the image, bind external port (443), flag HTTPS enabled, mount certificate:

```
docker run \
  -it
  -p 443:8080 \
  -e SERVER_ENABLE_HTTPS=true \
  -v $(pwd)/certs:/etc/nginx/certs:ro
  behance/docker-nginx
```

<details><summary>Click to show sample output</summary>

  $ docker run -it -p 443:8080 -e SERVER_ENABLE_HTTPS=true -v /Users/jmong/git/forks/docker-nginx/certs:/etc/nginx/certs:ro docker-nginx:test2
  [init] executing /run.d/99-nginx.sh
  [run] enabling web server
  [run] starting process manager
  [s6-init] making user provided files available at /var/run/s6/etc...exited 0.
  [s6-init] ensuring user provided files have correct perms...exited 0.
  [fix-attrs.d] applying ownership & permissions fixes...
  [fix-attrs.d] done.
  [cont-init.d] executing container initialization scripts...
  [cont-init.d] 10-nginx-config.sh: executing... 
  [nginx] missing $SERVER_APP_NAME to add to log lines, please add environment variable
  [nginx] enabling HTTPS
  [cont-init.d] 10-nginx-config.sh: exited 0.
  [cont-init.d] 11-nginx-validation.sh: executing... 
  [cont-init.d] 11-nginx-validation.sh: exited 0.
  [cont-init.d] done.
  [services.d] starting services
  [services.d] done.

</details>

Test
```
curl -k -vvv https://{your-docker-machine-ip}
```

<details><summary>Click to show sample output</summary>

  $ curl -k -vvv https://127.0.0.1/
  *   Trying 127.0.0.1...
  * TCP_NODELAY set
  * Connected to 127.0.0.1 (127.0.0.1) port 443 (#0)
  * ALPN, offering h2
  * ALPN, offering http/1.1
  * successfully set certificate verify locations:
  *   CAfile: /etc/ssl/cert.pem
    CApath: none
  * TLSv1.2 (OUT), TLS handshake, Client hello (1):
  * TLSv1.2 (IN), TLS handshake, Server hello (2):
  * TLSv1.2 (IN), TLS handshake, Certificate (11):
  * TLSv1.2 (IN), TLS handshake, Server key exchange (12):
  * TLSv1.2 (IN), TLS handshake, Server finished (14):
  * TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
  * TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
  * TLSv1.2 (OUT), TLS handshake, Finished (20):
  * TLSv1.2 (IN), TLS change cipher, Change cipher spec (1):
  * TLSv1.2 (IN), TLS handshake, Finished (20):
  * SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
  * ALPN, server accepted to use http/1.1
  * Server certificate:
  *  subject: CN=localhost
  *  start date: Jul 15 01:48:05 2022 GMT
  *  expire date: Jul 15 01:48:05 2023 GMT
  *  issuer: CN=localhost
  *  SSL certificate verify result: self signed certificate (18), continuing anyway.
  > GET / HTTP/1.1
  > Host: 127.0.0.1
  > User-Agent: curl/7.64.1
  > Accept: */*
  > 
  < HTTP/1.1 200 OK
  < Server: nginx
  < Date: Fri, 15 Jul 2022 01:54:00 GMT
  < Content-Type: text/html
  < Content-Length: 633
  < Last-Modified: Fri, 15 Jul 2022 00:33:23 GMT
  < Connection: keep-alive
  < ETag: "62d0b5d3-279"
  < X-XSS-Protection: 1; mode=block
  < X-Content-Type-Options: nosniff
  < Accept-Ranges: bytes
  < 
  <!DOCTYPE html>
  <html>
  <head>
  <title>Welcome to nginx!</title>
  [...snip...]
  <h1>It Works!</h1>
  * Connection #0 to host 127.0.0.1 left intact
  * Closing connection 0

</details>

