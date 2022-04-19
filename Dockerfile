FROM alpine
EXPOSE 80
RUN apk add --no-cache \
    ca-certificates \
    cgit \
    fcgiwrap \
    git \
    lua5.3-libs \
    py3-markdown \
    py3-pygments \
    python3 \
    spawn-fcgi \
    tzdata \
    xz \
    zlib \
    nginx
RUN rm -rf /var/cache/apk/*
RUN rm -rf /tmp/*

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./cgitrc /etc/cgitrc
COPY ./cgit.conf /etc/nginx/conf.d/cgit.conf

VOLUME [ "/data" ]

STOPSIGNAL SIGTERM

CMD spawn-fcgi \
        -u nginx -g nginx \
        -s /var/run/fcgiwrap.sock \
        -n -- /usr/bin/fcgiwrap \
    & nginx -g "daemon off;"
