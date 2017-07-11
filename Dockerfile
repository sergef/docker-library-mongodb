FROM sergef/docker-library-alpine:edge

EXPOSE 27017 28017

RUN apk add --no-cache \
    mongodb@community \
  && mkdir -p /data/db \
  && chown -R mongodb:mongodb /data/db

USER mongodb

CMD [ "mongod" ]
