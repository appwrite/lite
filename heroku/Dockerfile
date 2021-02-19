FROM appwrite/appwrite:0.7.0

LABEL maintainer="team@appwrite.io"

RUN \
  apk update \
  && apk add --no-cache supervisor redis


# copy supervisord conf
ADD root /



RUN echo db = ${JAWSDB_MARIA_URL} \
  && echo proto="$(echo $db | grep :// | sed -e's,^\(.*://\).*,\1,g')" \
  && echo url="$(echo ${db/$proto/})" \
  && echo userpass="$(echo $url | grep @ | cut -d@ -f1)" \
  && echo user="$(echo $userpass | grep : | cut -d: -f1)" \
  && echo pass="$(echo $userpass | grep : | cut -d: -f2)" \
  && echo hostport="$(echo ${url/$userpass@/} | cut -d/ -f1)" \
  && echo host="$(echo $hostport | sed -e 's,:.*,,g')" \
  && echo port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')" \
  && echo schema="$(echo $url | grep / | cut -d/ -f2-)"

# Environment
ENV _APP_EDITION=community-lite \
    _APP_STORAGE_ANTIVIRUS=disabled \
    _APP_REDIS_HOST=localhost \
    _APP_REDIS_PORT=6379 \
    _APP_USAGE_STATS=disabled \
    _APP_DB_HOST=${host} \
    _APP_DB_PORT=${port} \
    _APP_DB_SCHEMA=${schema} \
    _APP_DB_USER=${user} \
    _APP_DB_PASS=${pass}


CMD ["/usr/bin/supervisord","-n", "-c", "/etc/supervisord.conf"]