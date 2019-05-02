FROM ubuntu:18.10

ENV DEBIAN_FRONTEND noninteractive
ENV HUB_VERSION 2.7.0

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
    curl \
    gnupg2 \
    software-properties-common

# Ruby/rails installation
RUN \curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN \curl -sSL https://get.rvm.io | bash -s stable --rails
RUN /bin/bash -c "source /usr/local/rvm/scripts/rvm"
RUN touch ${home}/.bashrc
RUN echo "source /usr/local/rvm/scripts/rvm" >> ${home}/.bashrc
RUN /bin/bash -l -c "rvm install 2.4.2"
RUN /bin/bash -l -c "rvm install jruby-1.7.25"
RUN /bin/bash -l -c "rvm install jruby-9.1.14.0"
RUN /bin/bash -l -c "rvm use 2.6.0"

# Add repositories
RUN apt-get update && apt-get install -y software-properties-common
RUN apt-add-repository -y ppa:openjdk-r/ppa

# Package installation
RUN apt-get install -y \
    bash \
    bash-completion \
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
#RUN curl -sL https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz | tar zx --strip 2 -C /usr/local/bin hub-linux-amd64-${HUB_VERSION}/bin/hub

WORKDIR ${home}
USER ${user}

# AWS CLI installation
RUN /bin/bash -c "pip3 install awscli --upgrade --user"

COPY files/.initialise.sh ${home}/.initialise.sh
RUN echo "source ${home}/.initialise.sh" >> ${home}/.bashrc
