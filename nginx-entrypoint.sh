#!/usr/bin/env sh

set -e

# As suggested in the official documentation:
# https://github.com/docker-library/docs/tree/master/nginx#using-environment-variables-in-nginx-configuration
envsubst '$PHP_HOST' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'
