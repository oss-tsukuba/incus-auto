FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Tokyo
ENV TZ=${TZ}

ARG USERNAME=foo
ARG UID=1000

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get -y install \
    sudo

RUN id $UID && userdel $(id -un $UID) || : \
  && useradd -m -u $UID -s /bin/bash $USERNAME \
  && echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME \
  # delete passwd
  && passwd -d $USERNAME

COPY ./terraform/install-terraform.sh /install-terraform.sh
RUN bash /install-terraform.sh
