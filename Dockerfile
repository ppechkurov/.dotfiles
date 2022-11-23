FROM ubuntu
RUN apt-get update 
RUN apt-get install -y curl sudo git vim xz-utils x11-xkb-utils x11-xserver-utils
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'ubuntu:ubuntu' | chpasswd
RUN usermod -aG sudo ubuntu
USER ubuntu
ENV USER ubuntu
WORKDIR /home/ubuntu
COPY . /home/ubuntu/.dotfiles