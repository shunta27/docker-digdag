FROM openjdk:8u151-jre-alpine
LABEL maintainer "szyn"

ENV DIGDAG_VERSION 0.9.27

RUN apk add --no-cache \
  bash \
  curl \
  g++ \
  gcc \
  git \
  glib-dev \
  make \
  openssh \
  py-pip \
  python \
  python-dev \
  ruby \
  ruby-bundler \
  ruby-dev \
  ruby-json \
  java-jansi-native \
  java-jffi-native \
  java-jna-native \
  java-snappy-native \
  libc6-compat && \
  pip install --upgrade pip && \
  pip install python-dateutil && \
  sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd && \
  echo 'export PS1="[\[\e[1;34m\]\u\[\e[00m\]@\[\e[0;32m\]\h\[\e[00m\] \[\e[1;34m\]\W\[\e[00m\]]$ "' >> ~/.bashrc

# digdag
RUN curl -o /usr/local/bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-${DIGDAG_VERSION}" && \
  chmod +x /usr/local/bin/digdag

# embulk
RUN curl -o ~/.embulk/bin/embulk --create-dirs -L "https://dl.embulk.org/embulk-latest.jar" && \
  chmod +x ~/.embulk/bin/embulk

# path setting
RUN echo 'export PATH=$PATH:$HOME/bin:$HOME/.embulk/bin' >> ~/.bashrc
# embulk gem install
RUN ~/.embulk/bin/embulk gem install embulk-input-postgresql

WORKDIR /etc
ADD conf/digdag_postgres.conf digdag_postgres.conf
ADD conf/development.yml development.yml
ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

WORKDIR /src
ENTRYPOINT ["/etc/entrypoint.sh"]
