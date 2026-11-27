FROM appwrite/appwrite:2.7.4@sha256:5ba84a579acc75dea0562dca5850909b960b56b77073354e3f25a82e9dcad933

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