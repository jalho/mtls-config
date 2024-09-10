# mTLS with Nginx reverse proxy and Node.js upstream

1. Create mTLS CA certificate (`ca.crt`) and client certificate (`client.crt`
   wrapped in container `client.p12`):

   ```
   openssl genpkey -algorithm RSA -out ca.key -aes256 -pass "pass:pass-ca" \
   && openssl req -x509 -new -key ca.key -sha256 -days 3 -out ca.crt -subj "/CN=My Test CA" -passin "pass:pass-ca" \
   && openssl genpkey -algorithm RSA -out client.key \
   && openssl req -new -key client.key -out client.csr -subj "/CN=My mTLS Client Cert/GN=John/SN=Smith/serialNumber=12345" \
   && openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 3 -sha256 -passin "pass:pass-ca" \
   && openssl pkcs12 -export -out client.p12 -inkey client.key -in client.crt -certfile ca.crt -passout "pass:pass-client"
   ```

2. Create TLS server key (`server.key`) and certificate (`server.crt`):

   ```
   openssl genpkey -algorithm RSA -out server.key \
   && openssl req -x509 -new -key server.key -out server.crt -days 3 -subj "/CN=localhost"
   ```

3. Start the mTLS reverse proxy (Nginx with config `mtls-server-nginx.conf`):

   ```
   bash start.sh
   ```

4. Start the upstream:

   ```
   node upstream.mjs
   ```

5. Configure the web browser to use the client certificate created in step #1
   (`client.p12`). For example in Firefox (v129.0.2) go _Settings_, then
   _Privacy & Security_, then _View Certificates_, then _Your Certificates_,
   then _Import..._ and then select the `client.p12`.

   Then access the upstream via the mTLS reverse proxy with the web browser: Go
   to `https://localhost:8080/a`.
