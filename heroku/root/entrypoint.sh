#!/bin/sh
db=$JAWSDB_MARIA_URL
proto="$(echo $db | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url="$(echo ${db/$proto/})"
userpass="$(echo $url | grep @ | cut -d@ -f1)"
user="$(echo $userpass | grep : | cut -d: -f1)"
pass="$(echo $userpass | grep : | cut -d: -f2)"
hostport="$(echo ${url/$userpass@/} | cut -d/ -f1)"
host="$(echo $hostport | sed -e 's,:.*,,g')"
port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
schema="$(echo $url | grep / | cut -d/ -f2-)"

export _APP_DB_HOST=$host
export _APP_DB_PORT=$port
export _APP_DB_SCHEMA=$schema
export _APP_DB_USER=$user
export _APP_DB_PASS=$pass

# Redis
redis=$REDIS_URL
proto="$(echo $redis | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url="$(echo ${redis/$proto/})"
userpass="$(echo $url | grep @ | cut -d@ -f1)"
user="$(echo $userpass | grep : | cut -d: -f1)"
pass="$(echo $userpass | grep : | cut -d: -f2)"
hostport="$(echo ${url/$userpass@/} | cut -d/ -f1)"
host="$(echo $hostport | sed -e 's,:.*,,g')"
port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"

export _APP_REDIS_HOST=$host
export _APP_REDIS_PORT=$port
export _APP_REDIS_USER=$user
export _APP_REDIS_PASS=$pass

php /dbInit.php

/usr/bin/supervisord -n -c /etc/supervisord.conf