# Local Middleware

A [docker-compose] with a reverse proxy. Requires Docker
and access to the repo where your containers are stored. We're using hardcoded
tags, as we have no `latest` or `develop` image tags to reference. The tags
are the short-hash of the commits they were built from in github.

Use this sort of thing when you need to run a bunch of services behind a host:port. This one uses nginx.

![network diagram](docs/network.png)

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

The proxy will listen on [localhost](http://localhost).

## Using a Local Process for a Service

You may want to route back to your host machine for a particular endpoint. For example,
if I'm running the `widgets-api` service in my IDE on port 8080, then modify [default.conf](conf.d/default.conf) accordigly.

```nginx
location /widgets-api {
    # proxy_pass http://widgets-api/widgets;
    proxy_pass http://host.docker.internal:8080/widgets;
}
```

## Redis

Redis will be exposed to the host machine on port 6379. You can point to it in apps by setting the environment variable `REDIS_HOST=localhost`.

## Troubleshooting

- Is Docker Running?

### Looking up Container Image Hashes

Some containers aren't tagged with a branch name. You can use
the first 7 characters of the sha hash of the commit to identify
an image in the container repo.

If you have `gh`, the github cli installed, you can do this to update
[docker-compose]

```sh
# replace image tag with sha of latest commit to develop
repo=YOUR_REPO_HERE
hash=$(gh api --header 'Accept: application/vnd.github.v3.sha' --method GET "/repos/dmsi-io/$repo/commits/develop")
gsed -e "s/$repo:[[:alnum:]_-]\+/$repo:${hash:0:7}/" docker-compose.yaml
```


## Related Links

- [gcloud authentication for docker](https://cloud.google.com/container-registry/docs/advanced-authentication#gcloud-helper)
- [DMSi GCR](https://console.cloud.google.com/gcr/images/a2w-staging?authuser=0&project=a2w-staging)

[docker-compose]: ./docker-compose.yaml
