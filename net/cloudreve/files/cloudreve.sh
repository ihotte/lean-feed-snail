#!/bin/sh
cd /app/cloudreve || exit 1
exec /app/cloudreve/cloudreve "$@" >>/var/log/cloudreve.log 2>&1
exit $?

