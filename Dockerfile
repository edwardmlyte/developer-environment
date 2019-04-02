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

# Ruby installation

#RUN mkdir -p /home/${user}/.gnupg
#RUN echo "disable-ipv6" >> /home/${user}/.gnupg/dirmngr.conf
#RUN gpg --keyserver hkp://pool.sks-keyservers.net -v -v --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
#RUN gpg --keyserver hkp://keyserver.pgp.com:80 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable --rails

USER ${user}
WORKDIR /home/${user}
