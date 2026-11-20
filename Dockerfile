FROM appwrite/appwrite:2.7.2@sha256:c668f8f94e92e11771d63062bc9e04131cec0d718697c439fd0c4a7776c0b8bd

LABEL maintainer="team@appwrite.io"

RUN \
  apk update \
  && apk add --no-cache supervisor redis

# copy supervisord conf
ADD root /

# Environment
ENV _APP_EDITION=community-lite \
    _APP_STORAGE_ANTIVIRUS=disabled \
    _APP_REDIS_HOST=localhost \
    _APP_REDIS_PORT=6379 \
    _APP_USAGE_STATS=disabled

CMD ["/usr/bin/supervisord","-n", "-c", "/etc/supervisord.conf"]