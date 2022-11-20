FROM ubuntu
RUN apt-get update && apt-get install -y curl && apt install sudo
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'ubuntu:ubuntu' | chpasswd
RUN usermod -aG sudo ubuntu
RUN sudo apt-get install -y git
RUN sudo apt-get install -y vim && sudo apt-get install -y xz-utils
USER ubuntu
WORKDIR /home/ubuntu