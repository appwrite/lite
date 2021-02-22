FROM appwrite/appwrite:0.7.0

LABEL maintainer="team@appwrite.io"

RUN \
  apk update \
  && apk add --no-cache supervisor redis

# copy supervisord conf
ADD root /

RUN chmod +x /entrypoint.sh

# Environment
ENV _APP_EDITION=community-lite \
    _APP_STORAGE_ANTIVIRUS=disabled \
    _APP_REDIS_HOST=localhost \
    _APP_REDIS_PORT=6379 \
    _APP_USAGE_STATS=disabled \
    _APP_SETUP=self-hosted-heroku

ENTRYPOINT ["/entrypoint.sh"]