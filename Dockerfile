FROM alpine:latest

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin

RUN apk --update add nodejs git tar wget ca-certificates

RUN mkdir -p /tmp/src && cd /tmp/src \
    && wget https://github.com/coreos/fleet/releases/download/v0.11.1/fleet-v0.11.1-linux-amd64.tar.gz \
    && tar -xf fleet-v0.11.1-linux-amd64.tar.gz \
    && cp fleet-v0.11.1-linux-amd64/fleetctl /usr/bin/fleetctl \
    && git clone https://github.com/yodlr/CoreGI.git \
    && mkdir /src && mv CoreGI/* /src && cd /src \
    && npm install -g bower gulp \
    && npm install \
    && bower install --allow-root \
    && gulp \
    && npm uninstall -g bower gulp \
    && npm cache clear \
    && apk del --purge git tar wget ca-certificates \
    && rm -rf /go /tmp/* /var/cache/apk/* /root/.n*

EXPOSE 3000

WORKDIR /src

CMD ["/usr/bin/node", "index.js"]