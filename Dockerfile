FROM ubuntu:24.04

ENV DEBIAN_FRONTENT=noninteractive

RUN apt update && \ 
  apt install -y curl gpg

RUN curl -fsSL https://ppa.ablaze.one/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/Floorp.gpg && \ 
  curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list' && \ 
  apt update

ARG FLOORP_VERSION
RUN arg= ; [ -n "$FLOORP_VERSION" ] && arg="=$FLOORP_VERSION"; apt install -y floorp${arg} && rm -rf /var/lib/apt/lists/*

ENV DISPLAY=:0

WORKDIR $HOME

SHELL ["/bin/bash", "-l", "-c"]
ARG USER=root
ARG UID=0
ARG GID=0
RUN [[ "$UID" != "0" ]] && \
  userdel -r $(id -nu $UID) || : && \ 
  groupadd -f -g $GID $USER && \ 
  useradd -u $UID -g $GID $USER

ENTRYPOINT [ "floorp" ]
