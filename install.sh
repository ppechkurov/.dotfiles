# install nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# source nix
. ~/.nix-profile/etc/profile.d/nix.sh

# install packages
nix-env -iA \
  nixpkgs.zsh \
  nixpkgs.git \
  nixpkgs.antibody \
  nixpkgs.stow \
  nixpkgs.fzf \
  nixpkgs.ripgrep \
  nixpkgs.bat \
  nixpkgs.cmake \
  nixpkgs.pkg-config \
  nixpkgs.libfreetype6-dev \
  nixpkgs.libfontconfig1-dev \
  nixpkgs.libxcb-xfixes0-dev \
  nixpkgs.libxkbcommon-dev \
  nixpkgs.python3 \
  nixpkgs.lazygit \
  nixpkgs.exa \

# install docker
# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
 apt-get update
 apt-get install ca-certificates curl gnupg lsb-release

# Add Docker’s official GPG key:
 mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Use the following command to set up the repository:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null

# To install the latest version, run:
 apt-get update
 apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Post Install steps
 groupadd docker
 usermod -aG docker $USER 
newgrp docker

# stow dotfiles
stow git
stow p10k
stow zsh
stow alacritty

# add zsh as a login shell
command -v zsh |  tee -a /etc/shells

# use zsh as default shell
 chsh -s $(which zsh) $USER

# zsh plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm

exec zsh

# node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
nvm install node
nvm install-latest-npm
