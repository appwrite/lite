FROM composer:2.0 as step0

ARG TESTING=false
ENV TESTING=$TESTING

WORKDIR /usr/local/src/

COPY composer.lock /usr/local/src/
COPY composer.json /usr/local/src/

RUN composer update --ignore-platform-reqs --optimize-autoloader \
    --no-plugins --no-scripts --prefer-dist \
    `if [ "$TESTING" != "true" ]; then echo "--no-dev"; fi`

FROM php:7.4-cli-alpine as step1

ENV TZ=Asia/Tel_Aviv \
    PHP_REDIS_VERSION=5.3.0 \
    PHP_SWOOLE_VERSION=4.5.3 \
    PHP_XDEBUG_VERSION=sdebug_2_9-beta

RUN \
  apk add --no-cache --virtual .deps \
  make \
  automake \
  autoconf \
  gcc \
  g++ \
  tar \
  wget \
  git \
  zlib-dev \
  brotli-dev

RUN docker-php-ext-install sockets

RUN \
  # Redis Extension
  wget -q https://github.com/phpredis/phpredis/archive/$PHP_REDIS_VERSION.tar.gz && \
  tar -xf $PHP_REDIS_VERSION.tar.gz && \
  cd phpredis-$PHP_REDIS_VERSION && \
  phpize && \
  ./configure && \
  make && make install && \
  cd .. && \
  ## Swoole Extension
  git clone https://github.com/swoole/swoole-src.git && \
  cd swoole-src && \
  git checkout v$PHP_SWOOLE_VERSION && \
  phpize && \
  ./configure --enable-sockets --enable-http2 && \
  make && make install && \
  cd ..

FROM php:7.4-cli-alpine as final

LABEL maintainer="team@appwrite.io"

ARG VERSION=dev

ENV TZ=Asia/Tel_Aviv \
    _APP_SERVER=swoole \
    _APP_ENV=production \
    _APP_DOMAIN=localhost \
    _APP_DOMAIN_TARGET=localhost \
    _APP_HOME=https://appwrite.io \
    _APP_EDITION=community \
    _APP_OPTIONS_ABUSE=enabled \
    _APP_OPTIONS_FORCE_HTTPS=disabled \
    _APP_OPENSSL_KEY_V1=your-secret-key \
    _APP_STORAGE_LIMIT=100000000 \
    _APP_STORAGE_ANTIVIRUS=disabled \
    _APP_REDIS_HOST=redis \
    _APP_REDIS_PORT=6379 \
    _APP_DB_HOST=mariadb \
    _APP_DB_PORT=3306 \
    _APP_DB_USER=root \
    _APP_DB_PASS=password \
    _APP_DB_SCHEMA=appwrite \
    _APP_INFLUXDB_HOST=influxdb \
    _APP_INFLUXDB_PORT=8086 \
    _APP_STATSD_HOST=telegraf \
    _APP_STATSD_PORT=8125 \
    _APP_SMTP_HOST=smtp \
    _APP_SMTP_PORT=25 \
    _APP_FUNCTIONS_TIMEOUT=900 \
    _APP_FUNCTIONS_CONTAINERS=10 \
    _APP_SETUP=self-hosted \
    _APP_VERSION=$VERSION
#ENV _APP_SMTP_SECURE ''
#ENV _APP_SMTP_USERNAME ''
#ENV _APP_SMTP_PASSWORD ''

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN \
  apk update \
  && apk add --no-cache --virtual .deps \
  make \
  automake \
  autoconf \
  gcc \
  g++ \
  curl-dev \
  && apk add --no-cache \
  libstdc++ \
  yaml-dev \
  imagemagick \
  imagemagick-dev \
  certbot \
  docker-cli \
  && pecl install imagick yaml \ 
  && docker-php-ext-enable imagick yaml \
  && docker-php-ext-install sockets opcache pdo_mysql \
  && apk del .deps

WORKDIR /usr/src/code

COPY --from=step0 /usr/local/src/vendor /usr/src/code/vendor
COPY --from=step1 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/swoole.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/
COPY --from=step1 /usr/local/lib/php/extensions/no-debug-non-zts-20190902/redis.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/

# Add Source Code
COPY ./core/app /usr/src/code/app
COPY ./core/bin /usr/local/bin
COPY ./core/docs /usr/src/code/docs
COPY ./core/public /usr/src/code/public
COPY ./core/src /usr/src/code/src

# Set Volumes
RUN mkdir -p /storage/uploads && \
    mkdir -p /storage/cache && \
    mkdir -p /storage/config && \
    mkdir -p /storage/certificates && \
    mkdir -p /storage/functions && \
    mkdir -p /storage/debug && \
    chown -Rf www-data.www-data /storage/uploads && chmod -Rf 0755 /storage/uploads && \
    chown -Rf www-data.www-data /storage/cache && chmod -Rf 0755 /storage/cache && \
    chown -Rf www-data.www-data /storage/config && chmod -Rf 0755 /storage/config && \
    chown -Rf www-data.www-data /storage/certificates && chmod -Rf 0755 /storage/certificates && \
    chown -Rf www-data.www-data /storage/functions && chmod -Rf 0755 /storage/functions && \
    chown -Rf www-data.www-data /storage/debug && chmod -Rf 0755 /storage/debug 

# Letsencrypt Permissions
RUN mkdir -p /etc/letsencrypt/live/ && chmod -Rf 755 /etc/letsencrypt/live/

# Enable Extensions
RUN echo extension=swoole.so >> /usr/local/etc/php/conf.d/swoole.ini
RUN echo extension=redis.so >> /usr/local/etc/php/conf.d/redis.ini

RUN echo "opcache.preload_user=www-data" >> /usr/local/etc/php/conf.d/appwrite.ini
RUN echo "opcache.preload=/usr/src/code/app/preload.php" >> /usr/local/etc/php/conf.d/appwrite.ini
RUN echo "opcache.enable_cli = 1" >> /usr/local/etc/php/conf.d/appwrite.ini

EXPOSE 80

RUN ["ls", "app"]

CMD [ "php", "app/http.php", "-dopcache.preload=opcache.preload=/usr/src/code/app/preload.php" ]
