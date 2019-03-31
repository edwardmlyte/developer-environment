FROM ubuntu:18.10

ENV DEBIAN_FRONTEND noninteractive
ENV HUB_VERSION 2.7.0

# User setup
ARG user=developer
ARG home=/home/${user}
ARG uid=1000
ARG gid=1000

WORKDIR /

# Add user
RUN useradd -s /bin/bash -u 1000 {user}

# Package installation
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y \
    curl \
    vim

# Hub installation
RUN curl -sL https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz | tar zx --strip 2 -C /usr/local/bin hub-linux-amd64-${HUB_VERSION}/bin/hub
