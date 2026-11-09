FROM appwrite/appwrite:0.15.3@sha256:fea8cf3e1fe839dd7aba22aaea0abb6d982889e5b0f4607235db086c9bf8be6b

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