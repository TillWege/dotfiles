#!/bin/bash
cwd=$(pwd)
username=$USER
plattform="$(uname -s)"

function install_brew {
    echo 'checking if brew is already installed'
    if ! [ -x "$(command -v brew)" ]; then
        echo 'installing brew'
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$username/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        echo 'brew is already installed'
    fi  
}

function install_helix {
    echo 'checking if helix is already installed'

    if ! [ -x "$(command -v hx)" ]; then
        echo 'installing helix'
        brew install gcc
        brew tap helix-editor/helix
        brew install helix
    else
        echo 'helix is already installed'
    fi
}

function install_zsh {
    echo 'checking if zsh is already installed'
    if ! [ -x "$(command -v hx)" ]; then
        echo 'installing zsh'
        brew install zsh    
    else
        echo 'zsh is already installed'
    fi

    echo 'installing oh-my-zsh'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    echo 'installing p10k'
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    echo 'installing autosuggestions'
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    echo 'checking if thefuck is already installed'
    if ! [ -x "$(command -v thefuck)" ]; then
        echo 'installing thefuck'
        brew install thefuck
    else
        echo 'thefuck is already installed'
    fi

    echo 'checking if fzf is already installed'
    if ! [ -x "$(command -v fzf)" ]; then
        echo 'installing fzf'
        brew install fzf
        yes | $(brew --prefix)/opt/fzf/install
    else
        echo 'fzf is already installed'
    fi
        
}

function link_dotfiles {
    rm ~/.bash_logout
    ln -s $cwd/.bash_logout ~/.bash_logout
    rm ~/.bashrc
    ln -s $cwd/.bashrc ~/.bashrc
    rm ~/.gitconfig
    ln -s $cwd/.gitconfig ~/.gitconfig
    rm ~/.p10k.zsh
    ln -s $cwd/.p10k.zsh ~/.p10k.zsh
    rm ~/.profile
    ln -s $cwd/.profile ~/.profile
    rm ~/.tmux.conf
    ln -s $cwd/.tmux.conf ~/.tmux.conf
    rm ~/.zshrc
    ln -s $cwd/.zshrc ~/.zshrc
    rm ~/.zshprofile
    ln -s $cwd/.zprofile ~/.zprofile
}

if [ "$plattform" = "Linux" ]; then
    echo 'running under linux'
    install_brew
    install_zsh
    install_helix
    link_dotfiles
elif [ "$plattform" = "Darwin" ]; then
    echo 'running under MacOS'
    install_zsh
    install_helix
    link_dotfiles
else
    echo 'running under an unsuported OS (probably windows)'
    exit 1
fi