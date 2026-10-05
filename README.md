# yohannaftali/mariadb

[![Docker Pulls](https://img.shields.io/docker/pulls/yohannaftali/mariadb)](https://hub.docker.com/r/yohannaftali/mariadb)
[![Docker Image Size](https://img.shields.io/docker/image-size/yohannaftali/mariadb/latest)](https://hub.docker.com/r/yohannaftali/mariadb)

[MariaDB](https://hub.docker.com/_/mariadb) image preconfigured with **Asia/Jakarta (WIB, UTC+7)** as the container's local timezone.

Docker Hub: <https://hub.docker.com/r/yohannaftali/mariadb>

## Overview

This image is built `FROM` the official `mariadb` image and only changes the OS timezone (`TZ=Asia/Jakarta`, `/etc/localtime`, `/etc/timezone`). Everything else (entrypoint, environment variables, volumes, ports) behaves exactly like the official image, so see its [documentation](https://hub.docker.com/_/mariadb) for full usage.

## Tags

| Tag | Base image |
| --- | --- |
| `latest` | `mariadb:latest` |
| `<version>` (e.g. `11.4`, `10.11`) | `mariadb:<version>` |

## Quick start

```bash
docker run -d --name mariadb \
  -e MARIADB_ROOT_PASSWORD=change-me \
  -p 3306:3306 \
  -v mariadb-data:/var/lib/mysql \
  yohannaftali/mariadb:latest
```

Verify the timezone:

```bash
docker exec mariadb date
docker exec mariadb mariadb -uroot -pchange-me -e "SELECT NOW(), @@system_time_zone;"
```

### docker-compose

```yaml
services:
  db:
    image: yohannaftali/mariadb:latest
    restart: unless-stopped
    environment:
      MARIADB_ROOT_PASSWORD: change-me
      MARIADB_DATABASE: app
    ports:
      - "3306:3306"
    volumes:
      - mariadb-data:/var/lib/mysql

volumes:
  mariadb-data:
```

> Note: `@@system_time_zone` reports `WIB`; `@@time_zone` stays `SYSTEM`, so `NOW()` returns Jakarta time.

## Build (maintainers)

```bash
docker login

# latest
docker build -t yohannaftali/mariadb:latest .

# specific MariaDB version
docker build --build-arg MARIADB_VERSION=11.4 -t yohannaftali/mariadb:11.4 .

docker push yohannaftali/mariadb --all-tags
```

Multi-arch (amd64 + arm64):

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  --build-arg MARIADB_VERSION=11.4 \
  -t yohannaftali/mariadb:11.4 --push .
```

## Automated publishing

`.github/workflows/docker-publish.yml` builds and pushes the images on every push to `main`, weekly (to pick up upstream security fixes), and on manual dispatch. It also syncs this README to the Docker Hub **overview** and the short **description**.

Required GitHub repository secrets:

| Secret | Value |
| --- | --- |
| `DOCKERHUB_USERNAME` | `yohannaftali` |
| `DOCKERHUB_TOKEN` | Docker Hub access token with *Read, Write, Delete* scope |

To change which MariaDB versions are published, edit the `version` matrix in the workflow.

## Maintaining the Docker Hub repository

- **Overview**: synced from this `README.md` by the workflow (or paste it in *Repository → General*).
- **Short description**: set in the workflow (`short-description`), max 100 characters.
- **Category**: not exposed through the API; set manually in *Repository → Settings → Categories* (suggested: **Databases & Storage**).
- **Tags**: remove stale tags in *Repository → Tags*; the weekly rebuild keeps the maintained ones fresh.

## License

The Dockerfile in this repository is provided as-is. MariaDB is licensed under GPLv2; see the [official image](https://hub.docker.com/_/mariadb) for details.
