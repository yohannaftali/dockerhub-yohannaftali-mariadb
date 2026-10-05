ARG MARIADB_VERSION=latest
FROM mariadb:${MARIADB_VERSION}

LABEL org.opencontainers.image.title="mariadb" \
      org.opencontainers.image.description="Official MariaDB image configured with the Asia/Jakarta timezone" \
      org.opencontainers.image.authors="Yohan Naftali" \
      org.opencontainers.image.source="https://github.com/yohannaftali/dockerhub-yohannaftali-mariadb"

ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
