#!/bin/bash

WD=$(realpath $(dirname $0))
REV_PROXY_NGINX_CFG="$WD/mtls-server-nginx.conf"
REV_PROXY_SERVER_TLS_KEY="$WD/server.key"
REV_PROXY_SERVER_TLS_CRT="$WD/server.crt"
REV_PROXY_MTLS_CA_CRT="$WD/ca.crt"
REV_PROXY_IMAGE="nginx:1.23-bullseye@sha256:f5747a42e3adcb3168049d63278d7251d91185bb5111d2563d58729a5c9179b0"

docker run --rm -ti -d \
	--name mtls-rev-proxy \
	-p 127.0.0.1:8080:443/tcp \
	-v $REV_PROXY_NGINX_CFG:/etc/nginx/nginx.conf \
	-v $REV_PROXY_SERVER_TLS_KEY:/etc/nginx/server.key \
	-v $REV_PROXY_SERVER_TLS_CRT:/etc/nginx/server.crt \
	-v $REV_PROXY_MTLS_CA_CRT:/etc/nginx/ca.crt \
	$REV_PROXY_IMAGE

