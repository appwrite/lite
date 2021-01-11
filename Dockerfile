FROM appwrite/appwrite:dev

LABEL maintainer="team@appwrite.io"

RUN \
  apk update \
  && apk add --no-cache supervisor

# copy supervisord conf
COPY ./supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord","-n", "-c", "/etc/supervisord.conf"]