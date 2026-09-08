FROM docker.io/alpine:3.24.1

LABEL org.opencontainers.image.source=https://github.com/datf/adb-runner
LABEL org.opencontainers.image.description="Runner for adb"

# renovate: datasource=repology depName=alpine_3_24/android-tools-adb versioning=loose
ENV ADB_APK_VERSION="35.0.2-r21"

RUN apk add --update --no-cache \
    android-tools-adb=$ADB_APK_VERSION

WORKDIR /app

ENTRYPOINT ["sh"]
