# Grocy on Docker and Kubernetes

ERP beyond your fridge - now containerized and helmified! This is the docker repo of [grocy](https://github.com/grocy/grocy).

[![Docker Pulls](https://img.shields.io/docker/pulls/grocy/grocy-docker.svg)](https://hub.docker.com/r/grocy/grocy-docker/)
[![Docker Stars](https://img.shields.io/docker/stars/grocy/grocy-docker.svg)](https://hub.docker.com/r/grocy/grocy-docker/)

## Install Docker

Follow [these instructions](https://docs.docker.com/engine/installation/) to get Docker running on your server.

### To run using docker just do the following:

Available on Docker Hub (prebuilt) or built from source

```
> docker-compose pull # if you haven't pulled or built
> docker-compose up
```

And grocy should be accessible via `http://localhost:8080`. If you want to use https you can adjust the nginx configuration by mounting it inside the container as a volume or by extending the image.

Note: if you have not pulled any of the images from the repository, when you do an `up`, it will attempt to build from scratch!

### To pull the latest images to your machine:

```
docker pull grocy/grocy-docker:nginx
docker pull grocy/grocy-docker:grocy
```

Or just `docker-compose pull`.

### Environmental variables:

As of grocy v.1.24.1, ENV variables are accessible via the `docker-compose.yml` file as long as they are prefixed by `GROCY_`. For example, to change the language from english to french, you can modify

```
GROCY_CULTURE: en
```

to

```
GROCY_CULTURE: fr
```

### To build from scratch

```
docker-compose build
```

### Additional Information

The docker images build are based on [Alpine](https://hub.docker.com/_/alpine/), with an extremelly low footprint (less than 10 MB for nginx, and less than 70MB for grocy with php-fm. That number is eventually bumped up to 490MB after all the dependencies are downloaded, however).

## Helm Chart

You can use the Helm Chart to easily install grocy in Kubernetes using [Helm](http://helm.sh/).

For installing and upgrading you can use the following command.

```
helm upgrade --install grocy ./chart
```

You will want to have a look at [`values.yaml`](./chart/values.yaml) for the settings that are offered by the chart.

For example you will probably want to enable ingress and persistence, so you can create a file with your preferences, e.g. in `my-values.yaml`:

```yaml
ingress:
  enabled: true
  annotations:
    ingress.kubernetes.io/proxy-body-size: 50m
  hosts:
  - host: my-grocy.example.com
    paths:
    - '/'

persistence:
  enabled: true
  accessMode: ReadWriteOnce
  size: 1Gi
```

Be aware that it probably is not a good idea to increase `replicaCountPhp` as grocy uses a sqlite database. Under the `config` section you can add all environment variables that grocy accepts, e.g.:

```yaml
config:
  GROCY_CULTURE: de
```

You need to specify your values file during install and update:

```
helm upgrade --install -f my-values.yaml grocy ./chart
```

## License
The MIT License (MIT)
