# Barebones Local Reverse Proxy

A [docker-compose.yaml](docker-compose.yaml) with a reverse proxy. Requires Docker
and access to the repo where your containers are stored. We're using hardcoded
tags, as we have no `latest` or `develop` image tags to reference. The tags
are the short-hash of the commits they were built from in github.

Use this sort of thing when you need to run a bunch of services behind a single url. This one uses nginx.

## Requirements

- Docker
- Google Container Registry access
- gcloud cli

## Usage

Log in to GCR so you can pull images. You may need to [install gcloud cli](https://cloud.google.com/sdk/docs/install).

```sh
gcloud init
gcloud auth login
gcloud auth configure-docker
```

Launch the services.

```sh
docker-compose up --abort-on-container-exit
```
## Using a Local Container

You may want to route back to your host machine for a particular endpoint. For example,
if I'm running the `widges-api` service in my IDE on port 8080, then modify [default.conf](conf.d/default.conf) accordigly.


```nginx
location /widgets-api {
    proxy_pass http://host.docker.internal:8080/widgets;
}
```

## Redis

Redis will be exposed to the host machine on port 6379. You can point to it in apps by setting the environment variable `REDIS_HOST=localhost`.

## Related Links

- [gcloud authentication](https://cloud.google.com/container-registry/docs/advanced-authentication#gcloud-helper)
- [DMSi GCR](https://console.cloud.google.com/gcr/images/a2w-staging?authuser=0&project=a2w-staging)