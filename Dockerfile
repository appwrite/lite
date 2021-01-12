FROM appwrite/appwrite:dev

LABEL maintainer="team@appwrite.io"

RUN \
  apk update \
  && apk add --no-cache supervisor redis


# copy supervisord conf
ADD root /

CMD ["/usr/bin/supervisord","-n", "-c", "/etc/supervisord.conf"]