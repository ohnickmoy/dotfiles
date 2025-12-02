#!/usr/bin/env bash

# cd "$(dirname "${BASH_SOURCE}")";

# git pull origin main;

# function doIt() {
# 	rsync --exclude ".git/" \
# 		--exclude ".DS_Store" \
# 		--exclude ".osx" \
# 		--exclude "bootstrap.sh" \
# 		--exclude "README.md" \
# 		--exclude "LICENSE-MIT.txt" \
# 		-avh --no-perms . ~;
# 	source ~/.bash_profile;
# }

# if [ "$1" == "--force" -o "$1" == "-f" ]; then
# 	doIt;
# else
# 	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
# 	echo "";
# 	if [[ $REPLY =~ ^[Yy]$ ]]; then
# 		doIt;
# 	fi;
# fi;
# unset doIt;

#!/bin/bash

set -e

# Check for Xcode Command Line Tools and install if not present
echo "Installing Xcode Command Line Tools..."
xcode-select --install || echo "Xcode Command Line Tools already installed."

# Install Homebrew if not already installed
echo "Installing Homebrew..."
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$($(brew --prefix)/bin/brew shellenv)"' >> ~/.zshrc
  eval "$($(brew --prefix)/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi

# Install tools with Homebrew
echo "Installing essential tools with Homebrew..."
brew install git
brew install kubectl
brew install python
brew install zsh
brew install tmux
brew install node
brew install kubectx
brew install jq
brew install yq 
brew install wget
brew install tree
brew install k9s
brew install m1-terraform-provider-helper
brew install terraform
brew install tfswitch

# Install iTerm2
echo "Installing iTerm2..."
brew install --cask iterm2

# Install VS Code
echo "Installing Visual Studio Code..."
brew install --cask visual-studio-code

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"\else
  echo "Oh My Zsh is already installed."
fi

# Install Powerlevel10k theme
echo "Installing Powerlevel10k Zsh theme..."
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
else
  echo "Powerlevel10k is already installed."
fi

# Install Python packages
echo "Installing Python packages..."
python3 -m pip install --upgrade pip
python3 -m pip install virtualenv

# Apply configurations
echo "Applying configurations..."
if ! grep -q "alias ll='ls -la'" ~/.zshrc; then
  echo "alias ll='ls -la'" >> ~/.zshrc
fi
echo "source ~/.zshrc" | zsh

# Install Kubernetes tools (optional)
read -p "Do you want to install additional Kubernetes tools like Helm? (y/n): " install_k8s_tools
if [[ "$install_k8s_tools" == "y" ]]; then
  echo "Installing Helm..."
  brew install helm
fi

# Migrate VS Code extensions
echo "Migrating VS Code extensions..."
if [ -f vscode-extensions.txt ]; then
  while read extension; do
    code --install-extension "$extension"
  done < vscode-extensions.txt
else
  echo "No vscode-extensions.txt file found. Skipping extension migration."
fi

# Set up Git configuration
git config --global user.name "ohnickmoy"
git config --global user.email "nick.moi@gmail.com"

# Finish
cat <<EOF

Setup complete! Please restart your terminal or run:
  source ~/.zshrc

If you want to configure Powerlevel10k, run:
  p10k configure
EOF

