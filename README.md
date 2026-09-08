# adb-runner

[![GitHub Release](https://img.shields.io/github/v/release/datf/adb-runner?style=flat-square)](https://github.com/datf/adb-runner/releases)
[![Container Image](https://img.shields.io/badge/ghcr.io-datf%2Fadb--runner-blue?style=flat-square&logo=docker)](https://github.com/datf/adb-runner/pkgs/container/adb-runner)
[![Platforms](https://img.shields.io/badge/platforms-linux%2Famd64%20%7C%20linux%2Farm64-informational?style=flat-square)](https://github.com/datf/adb-runner/pkgs/container/adb-runner)
[![Base Image](https://img.shields.io/badge/base-Alpine%20Linux-24292e?style=flat-square&logo=alpinelinux)](https://alpinelinux.org/)
[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg?style=flat-square)](LICENSE)

An ultra-lightweight, zero-friction container image providing the Android Debug Bridge (`adb`) thanks to Alpine Linux.

Pre-built and ready to run with **Podman** or **Docker** on both `linux/amd64` and `linux/arm64` (Apple Silicon, Raspberry Pi, and x86_64).

---

## Why adb-runner?

Installing the official Android SDK command-line tools often pulls in Java runtimes, hundreds of megabytes (or gigabytes) of SDK components, and clutters your host system path.

**adb-runner** keeps things minimal, clean, and honest:

- **Featherweight**: Built directly on official Alpine Linux with only `android-tools-adb`. The entire image is under **20 MB** download size (compared to 500MB+ for standard Android SDK containers).
- **Multi-Architecture**: Multi-arch builds for `linux/amd64` and `linux/arm64`.
- **Always Up-to-Date**: Automated dependency tracking via Renovate continuously checks upstream Alpine repositories and rebuilds the container whenever `android-tools-adb` or the Alpine base image receives an update.
- **Ephemeral & Clean**: Mount your APKs or scripts, do what you need to do, and exit. No lingering daemons or unwanted files on your host.
- **Ready for CI/CD & Local Dev**: Perfect for GitHub Actions, GitLab CI, local development, wireless debugging, and sideloading APKs.

---

## Quickstart

Run an interactive shell right away:

```bash
# Using Podman
podman run -it --rm ghcr.io/datf/adb-runner:latest

# Using Docker
docker run -it --rm ghcr.io/datf/adb-runner:latest
```

### Mount the Current Directory into `/app`

Mount your current host directory (containing your `.apk` files or scripts) into the container's working directory (`/app`):

```bash
# Using Podman (with SELinux ':z' flag)
podman run -it --rm -v "$(pwd):/app:z" ghcr.io/datf/adb-runner:latest

# Using Docker
docker run -it --rm -v "$(pwd):/app:z" ghcr.io/datf/adb-runner:latest
```

---

## Shell Aliases

You can add an alias to your `~/.bashrc` or `~/.zshrc` so you can launch the container from any directory just like a native command:

```bash
# For Podman users (recommended)
alias copier='podman run -it --rm -v "$(pwd):/app:z" ghcr.io/datf/adb-runner:latest'
alias adb-runner='podman run -it --rm -v "$(pwd):/app:z" ghcr.io/datf/adb-runner:latest'

# For Docker users
alias copier='docker run -it --rm -v "$(pwd):/app:z" ghcr.io/datf/adb-runner:latest'
alias adb-runner='docker run -it --rm -v "$(pwd):/app:z" ghcr.io/datf/adb-runner:latest'
```

---

## Building and Running Locally

If you prefer to build and run the image from source, a `docker-compose.yml` file is included:

```bash
# Clone the repository
git clone https://github.com/datf/adb-runner
cd adb-runner

# Build the image
docker compose build

# Launch the container with the current directory mounted at /app
docker compose run --rm -it adb
```

Your current path will be mounted on `/app`, where all your local files will be accessible.

---

## Need Fastboot?

The base image intentionally keeps its footprint minimal by including only ADB. If you need `fastboot` for flashing partitions or unlocking bootloaders, you can easily install it on the fly inside the running container:

```sh
apk add --update android-tools-fastboot
```

Or, if you build locally and want it pre-installed, simply add `android-tools-fastboot` to the `RUN apk add` instruction in `Dockerfile`.

---

## Common ADB Usage Examples

### 1. Wireless Debugging (Over Wi-Fi)

Make sure your Android device and host machine are on the same network (or the host can reach the device IP):

```sh
# Inside adb-runner shell:
adb connect 192.168.1.150:5555
adb devices
adb shell
```

### 2. Sideloading / Installing an APK

Place your APK in the directory from which you launch `adb-runner` (so it appears in `/app`):

```sh
# Inside adb-runner shell:
adb install my-app.apk
```

### 3. USB Passthrough (Optional)

To connect to physical devices via USB cable, pass the host's USB bus devices into the container:

```bash
# Podman / Docker with USB passthrough
docker run -it --rm --privileged -v /dev/bus/usb:/dev/bus/usb -v "$(pwd):/app:z" ghcr.io/datf/adb-runner:latest
```

---

## Automated Updates

This repository uses automated dependency management powered by [Renovate](https://github.com/renovatebot/renovate). 

The `Dockerfile` pins both the Alpine base image and `android-tools-adb` package version:

```dockerfile
# renovate: datasource=repology depName=alpine_3_24/android-tools-adb versioning=loose
ENV ADB_APK_VERSION="35.0.2-r21"
```

Whenever Alpine updates the `android-tools` package in its official repositories, Renovate opens a pull request and the GitHub Actions release workflow builds and pushes multi-architecture images to GitHub Container Registry (`ghcr.io`).

---

## Acknowledgements

A huge thank you to the **[Alpine Linux](https://alpinelinux.org/) developers and package maintainers**! Their work packaging Android platform tools (`android-tools-adb`, `android-tools-fastboot`) into clean, standalone Alpine packages makes ultra-lightweight utilities like this possible without the bloat of full SDK toolchains.

---

## License

This project is free and unencumbered software released into the public domain under [The Unlicense](LICENSE).
