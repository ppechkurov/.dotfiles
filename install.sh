set -e

echo '======> installing brew...'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo '======> installing packages...'
brew install zsh \
	git \
	stow \
	fzf \
	ripgrep \
	bat \
	cmake \
	lazygit \
	lazydocker \
	eza \
	tmux \
	mycli \
	neovim

echo '======> brew packages installed'

# add zsh as a login shell
command -v zsh | sudo tee -a /etc/shells

# use zsh as default shell
sudo chsh -s "$(which zsh)" "$USER"
echo '======> zsh as default shell'

echo '======> installing oh-my-zsh...'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo '======> oh-my-zsh installed'

# zsh plugins
echo '======> installing zsh plugins...'

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}/plugins/zsh-completions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search"
git clone https://github.com/lukechilds/zsh-nvm "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/.oh-my-zsh/custom/plugins/zsh-nvm"
git clone https://github.com/jeffreytse/zsh-vi-mode "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/.oh-my-zsh/custom/plugins/zsh-vi-mode"
git clone https://github.com/lincheney/fzf-tab-completion "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab-completion"
git clone https://github.com/reegnz/jq-zsh-plugin.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/jq"

rm -rf ~/.zshrc

echo '======> plugins installed'

echo '======> stowing dotfiles...'

stow git
stow p10k
stow zsh
stow alacritty
# stow astronvim
# stow wezterm

echo '======> stowed'

echo '======> installing node...'

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
. ~/.nvm/nvm.sh
nvm install node
nvm install-latest-npm

echo '======> node installed'

echo '======> installing nerd fonts...'

font_name=ShareTechMono
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/${font_name}.zip
unzip "${font_name}.zip" "*.ttf" "*.otf" -d ${HOME}/.fonts
fc-cache -f -v
rm -rf *.zip

echo '======> font installed'

exec zsh
