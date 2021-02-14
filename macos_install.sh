# change the default folder for screenshots
mkdir -p $HOME/Pictures/screenshots
defaults write com.apple.screencapture location $HOME/Pictures/screenshots && killall SystemUIServer

# install xcode-select
xcode-select --install

# install homebrew
# TODO: make this step interactive to check and approve script before running
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# # add homebrew installation location to path
# # TODO: get installation path dynamically
# echo 'export PATH="/opt/homebrew/bin:$PATH"' >> $HOME/.bashrc
# echo 'export PATH="/opt/homebrew/bin:$PATH"' >> $HOME/.zshrc

# add necessary taps necessary
brew tap homebrew/cask-fonts	# nerd fonts

# install homebrew casks
brew install --cask \
alfred \
iterm2 \
font-hack-nerd-font \
font-mononoki-nerd-font \

# install brew packages
brew install \
git \
wget \
node \
poetry \
cookiecutter \ 

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# get spaceship-prompt theme for oh-my-zsh
git clone https://github.com/reobin/typewritten.git $ZSH_CUSTOM/themes/typewritten
ln -s "$ZSH_CUSTOM/themes/typewritten/typewritten.zsh-theme" "$ZSH_CUSTOM/themes/typewritten.zsh-theme"
ln -s "$ZSH_CUSTOM/themes/typewritten/async.zsh" "$ZSH_CUSTOM/themes/async"

# #--------------------#
# # install doom emacs #
# #--------------------#

# install dependencies
brew install \
ripgrep \
coreutils \
fd \
cmake \

# get emacs
brew tap d12frosted/emacs-plus
brew install emacs-plus

# add to Applications directory
cp -r /opt/homebrew/opt/emacs-plus/Emacs.app /Applications/Emacs.app

# get doom emacs
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install

# # add doom to path
# echo 'export PATH="$HOME/.emacs.d/bin:$PATH"' >> $HOME/.bashrc
# echo 'export PATH="$HOME/.emacs.d/bin:$PATH"' >> $HOME/.zshrc

# create symlinks
ln -s $HOME/.dotfiles/.bashrc $HOME/
ln -s $HOME/.dotfiles/.zshrc $HOME/
ln -s $HOME/.dotfiles/.doom.d $HOME/
