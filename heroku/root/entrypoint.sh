#!/bin/sh
JAWSDB_MARIA_URL=mysql://f1096vrzhlyc7hhe:vn9tyiy27p615ozd@klbcedmmqp7w17ik.cbetxkdyhwsb.us-east-1.rds.amazonaws.com:3306/nk1qz3yp9k27nd0y
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

/usr/bin/supervisord -n -c /etc/supervisord.conf