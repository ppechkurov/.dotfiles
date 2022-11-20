# install nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# source nix
. ~/.nix-profile/etc/profile.d/nix.sh

# install packages
nix-env -iA \
  nixpkgs.zsh \
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
  nixpkgs.lazygit

# stow dotfiles
stow git
stow p10k
stow zsh
stow alacritty

# add zsh as a login shell
command -v zsh | sudo tee -a /etc/shells

# use zsh as default shell
sudo chsh -s $(which zsh) $USER

# bundle zsh plugins
antibody bundle <~/.zsh_plugins.txt >~/.zsh_plugins.sh

exec zsh

# node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
nvm install node
nvm install-latest-npm
