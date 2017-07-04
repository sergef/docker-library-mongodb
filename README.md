# Docker base images

## MongoDB

Using mongodb@community Alpine linux package
https://pkgs.alpinelinux.org/package/edge/community/x86_64/mongodb. 

Don't forget to configure a data store volume,
simple example:

```
mongodb:
  restart: always
  image: sergef/docker-library-mongodb:3.4.4
  ports:
    - 27017:27017
  volumes:
    - .tmp/mongodb:/data/db
```
