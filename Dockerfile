FROM sergef/docker-library-alpine:edge

EXPOSE 27017 28017

RUN apk add --no-cache \
  mongodb@community

USER mongodb

CMD [ "mongod" ]
