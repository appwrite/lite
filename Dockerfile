FROM appwrite/appwrite:0.8.0@sha256:e7eaef013ceddf91c5ccc17e47819ac56d413d2888f47b6f77a52ae2d5489d24

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