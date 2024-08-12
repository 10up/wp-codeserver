ARG PHP_VERSION=8.2

# Set a BASE_IMAGE CI var to specify a different base image
ARG BASE_IMAGE=ghcr.io/10up/wp-php-fpm-dev
ARG UBUNTU_RELEASE_NAME=jammy
FROM ${BASE_IMAGE}:${PHP_VERSION}-${UBUNTU_RELEASE_NAME}

ARG PHP_VERSION=8.2


USER root
RUN apt-get update && \
  apt-get install -y \
  python3-pip \
  zsh \
  glances \
  silversearcher-ag \
  tmux \
  screen \
  jq \
  parallel \
  build-essential && \
  apt clean all && rm -rf /var/lib/apt/lists/*


RUN \
  if [ $(grep VERSION_CODENAME /etc/os-release | cut -d '=' -f 2) = 'jammy' ]; then \
    pip3 --no-cache-dir install \
      python-gitlab \
      mitzasql \
      ranger-fm; \
  else \
    pip3 --no-cache-dir install --break-system-packages \
      python-gitlab \
      mitzasql \
      ranger-fm; \
  fi


RUN \
  curl -fsSL https://code-server.dev/install.sh | sh; \
  rm -rf ~/.cache

RUN chsh -s /bin/bash www-data

COPY code-server-entrypoint.sh /
COPY bash.sh /
RUN \
    chmod +x /code-server-entrypoint.sh && \
    chmod +x /bash.sh

USER www-data
RUN \
  touch ~/.zshrc; \
  mkdir ~/.parallel; \
  touch ~/.parallel/will-cite

WORKDIR /var/www/html

SHELL ["/bin/bash"]
ENTRYPOINT ["/code-server-entrypoint.sh"]
