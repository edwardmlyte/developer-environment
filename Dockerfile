FROM ubuntu:18.10

ENV DEBIAN_FRONTEND noninteractive
ENV HUB_VERSION 2.7.0

# User setup
ARG user=developer
ARG uid=1000

WORKDIR /

# Add user
RUN useradd -s /bin/bash -u ${uid} ${user}

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils software-properties-common

# Add repositories
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-add-repository -y ppa:openjdk-r/ppa

# Package installation
RUN apt-get install -y \
    bash \
    bash-completion \
    curl \
    docker \
    dos2unix \
    git \
    gnupg2 \
    jq \
    openjdk-8-jdk \
    tree \
    unzip \
    vim \
    wget

# Hub installation
RUN curl -sL https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz | tar zx --strip 2 -C /usr/local/bin hub-linux-amd64-${HUB_VERSION}/bin/hub

# Ruby/rails installation
RUN \curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN \curl -sSL https://get.rvm.io | bash -s stable --rails

USER ${user}
WORKDIR /home/${user}
