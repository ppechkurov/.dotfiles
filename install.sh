set -e

# install nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
echo '======> nix installed'

# source nix
. ~/.nix-profile/etc/profile.d/nix.sh

# install packages
nix-env -iA \
  nixpkgs.zsh \
  nixpkgs.git \
  nixpkgs.stow \
  nixpkgs.fzf \
  nixpkgs.ripgrep \
  nixpkgs.bat \
  nixpkgs.cmake \
  nixpkgs.lazygit \
  nixpkgs.exa \
  nixpkgs.xcape \
  nixpkgs.neovim

echo '======> nix packages installed'

curl -LO https://github.com/wez/wezterm/releases/download/20221119-145034-49b9839f/wezterm-20221119-145034-49b9839f.Ubuntu22.04.deb
sudo apt install -y ./wezterm-20221119-145034-49b9839f.Ubuntu22.04.deb

# add zsh as a login shell
command -v zsh | sudo tee -a /etc/shells

# use zsh as default shell
sudo chsh -s "$(which zsh)" "$USER"
echo '======> zsh as default shell'

# install ohmhzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo '======> oh-my-zsh installed'

# zsh plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search"
git clone https://github.com/lukechilds/zsh-nvm "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm"
echo '======> plugins installed'

rm -rf ~/.zshrc

# stow dotfiles
stow git
stow p10k
stow zsh
# stow alacritty
stow astronvim
stow wezterm
echo '======> stowed'

# node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node
nvm install-latest-npm
echo '======> nvm installed'

# AstroNvim
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim

exec zsh
