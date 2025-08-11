# .config

My personal dotfiles and configuration for macOS development environment.

## Overview

This repository contains my personal configuration files (dotfiles) for various tools and applications I use in my development workflow. It's designed to quickly set up a consistent environment across different machines.

## What's Included

- **Terminal Setup**
  - Alacritty & Ghostty terminal configurations
  - Tmux configuration with Tokyo Night theme
  - Fish & Zsh shell configurations
  - Oh-My-Fish (OMF) setup

- **Development Tools**
  - Neovim configuration with LSP support and custom plugins
  - Lazygit configuration
  - Fish shell functions and completions
  - NVM, PNPM, and Pyenv configurations

- **Window Management**
  - Yabai for tiling window management
  - SKHD for keyboard shortcuts
  - Custom scripts for window management

- **CLI Replacements**
  - bat (for cat)
  - fd (for find)
  - ripgrep (for grep)
  - eza (for ls)
  - procs (for ps)

## Getting Started

### Quick Install

Run the included setup script to install all required dependencies:

```bash
~/.config/setup.sh
```

This script will:
1. Install Homebrew if not already installed
2. Install all required command line tools
3. Set up Oh-My-Zsh
4. Configure Tmux Plugin Manager
5. Set up NVM and Python environments
6. Configure Neovim plugins
7. Enable Yabai and SKHD services

### Manual Installation

If you prefer to install components individually, check the `setup.sh` script for the list of dependencies and installation commands.

## Key Features

- Modern terminal experience with true color support
- Efficient window management with keyboard shortcuts
- Optimized Neovim setup for development
- Fast modern replacements for common Unix tools
- Tmux configuration for better terminal multiplexing

## Customization

Feel free to fork this repository and modify the configurations to suit your preferences. Most configuration files include comments explaining specific settings.

## License

This project is open source and available under the MIT License.