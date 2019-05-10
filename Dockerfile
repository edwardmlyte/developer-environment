FROM ubuntu:19.04

ENV DEBIAN_FRONTEND noninteractive

# User setup
ARG user=developer
ARG uid=1000
ARG home=/home/${user}

WORKDIR /

# Add user
RUN useradd -ms /bin/bash -u ${uid} ${user}

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    apt-utils \
    software-properties-common

# Add repositories
RUN apt-add-repository -y ppa:openjdk-r/ppa

# Package installation
RUN apt-get install -y \
    bash \
    bash-completion \
    curl \
    docker \
    dos2unix \
    git \
    jq \
    openjdk-8-jdk \
    python \
    python3-pip \
    sudo \
    tree \
    unzip \
    vim \
    wget

# Hub installation
ENV HUB_VERSION 2.11.2
RUN curl -sL https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz | tar zx --strip 2 -C /usr/local/bin hub-linux-amd64-${HUB_VERSION}/bin/hub

WORKDIR ${home}
USER ${user}

# AWS CLI installation
RUN /bin/bash -c "pip3 install awscli --upgrade --user"

COPY files/.initialise.sh ${home}/.initialise.sh
RUN echo "source ${home}/.initialise.sh" >> ${home}/.bashrc
