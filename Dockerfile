ARG PHP_VERSION=7.4
FROM 10up/wp-php-fpm-dev:${PHP_VERSION}-ubuntu

ARG PHP_VERSION=7.4


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
  pip3 --no-cache-dir install \
    python-gitlab \
    mitzasql \
    ranger-fm

COPY code-server-entrypoint.sh /
COPY bash.sh /
RUN \
    chmod +x /code-server-entrypoint.sh && \
    chmod +x /bash.sh

RUN \
  curl -fsSL https://code-server.dev/install.sh | sh; \
  rm -rf ~/.cache

RUN chsh -s /bin/bash www-data
USER www-data
RUN \
  touch ~/.zshrc; \
  mkdir ~/.parallel; \
  touch ~/.parallel/will-cite
WORKDIR /var/www/html

SHELL ["/bin/bash", "-lc"]
ENTRYPOINT ["/code-server-entrypoint.sh"]
