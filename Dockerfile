FROM ubuntu
RUN apt-get update 
RUN apt-get install -y curl sudo git vim xz-utils
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'ubuntu:ubuntu' | chpasswd
RUN usermod -aG sudo ubuntu
USER ubuntu
ENV USER ubuntu
WORKDIR /home/ubuntu
# ENV PATH="/home/ubuntu/.nix-profile/bin:${PATH}"