#!/bin/bash

# setup.sh - Install all dependencies needed for .config setup
# Created by opencode

# Exit on error
set -e

echo "Starting setup for .config dependencies..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed, updating..."
    brew update
fi

# Install command line tools
echo "Installing command line tools..."
brew install \
    neovim \
    tmux \
    yabai \
    skhd \
    lazygit \
    bat \
    fd \
    ripgrep \
    eza \
    procs \
    jq \
    neofetch \
    pyenv \
    nvm \
    pnpm

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh already installed"
fi

# Setup Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "Tmux Plugin Manager already installed"
fi

# Configure tmux to use .config/tmux folder
echo "Configuring tmux to use .config/tmux folder..."
if [ ! -f "$HOME/.tmux.conf" ] || ! grep -q "source-file ~/.config/tmux/.tmux.conf" "$HOME/.tmux.conf"; then
    echo "source-file ~/.config/tmux/.tmux.conf" > "$HOME/.tmux.conf"
    echo "Created ~/.tmux.conf that sources your config from ~/.config/tmux/.tmux.conf"
else
    echo "~/.tmux.conf already configured"
fi

# Setup NVM
if [ ! -d "$HOME/.nvm" ]; then
    echo "Setting up NVM..."
    mkdir -p "$HOME/.nvm"
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    nvm install --lts
else
    echo "NVM already installed"
fi

# Setup Python with pyenv
echo "Setting up Python with pyenv..."
eval "$(pyenv init -)"
if ! pyenv versions | grep -q "3.8"; then
    pyenv install 3.8
    pyenv global 3.8
fi

# Setup Neovim plugins
echo "Setting up Neovim..."
if [ -f "$HOME/.config/nvim/install_lsp.sh" ]; then
    chmod +x "$HOME/.config/nvim/install_lsp.sh"
    "$HOME/.config/nvim/install_lsp.sh"
else
    echo "Neovim LSP installer script not found, skipping"
fi

# Configure Yabai with SIP partial disabled
echo "Note: To use all Yabai features, you'll need to disable System Integrity Protection partially."
echo "See https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection for more information."

# Enable services
echo "Enabling services..."
brew services start yabai
brew services start skhd

echo "Setup complete! You may need to restart your terminal to apply all changes."
echo "Tmux is configured to use your ~/.config/tmux/.tmux.conf file automatically."
