FROM %DOCKER_REGISTRY%docker-library-alpine

ENV DB_USER mongodb
ENV DB_PASSWORD mongodb
ENV DB_NAME negzon
ENV DB_ROLE dbOwner
ENV DB_STORAGE_ENGINE mmapv1
ENV DB_JOURNALING nojournal
ENV DB_MOUNTPOINT /data/db

ENV MONGODB_VERSION 3.2.4
ENV MONGODB_PORT 27017
ENV MONGODB_ARGS ""

EXPOSE $MONGODB_PORT

VOLUME $DB_MOUNTPOINT
RUN mkdir -p $DB_MOUNTPOINT

# https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk
COPY glibc-2.21-r2.apk /tmp/glibc-2.21-r2.apk
# https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk
COPY glibc-bin-2.21-r2.apk /tmp/glibc-bin-2.21-r2.apk

RUN apk update \
  && apk add \
    ca-certificates \
    libgcc \
    libstdc++ \
    tar \
  && apk add --allow-untrusted /tmp/glibc-2.21-r2.apk \
  && apk add --allow-untrusted /tmp/glibc-bin-2.21-r2.apk \
  && /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib

ADD https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-${MONGODB_VERSION}.tgz /tmp

RUN tar -xzf /tmp/mongodb-linux-x86_64-${MONGODB_VERSION}.tgz --strip 1 -C /usr \
  && rm -rf /tmp/* /var/cache/apk/*

ENTRYPOINT rm /data/db/mongod.lock || true
  /usr/bin/mongod \
    --dbpath $DB_MOUNTPOINT \
    --port $MONGODB_PORT \
    --storageEngine $DB_STORAGE_ENGINE \
    --$DB_JOURNALING \
    $MONGODB_ARGS
