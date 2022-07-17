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

    echo 'checking if oh-my-zsh is already installed'
    if [ -d ~/.oh-my-zsh ]; then
        echo 'oh-my-zsh is already installed'
    else
        echo 'installing oh-my-zsh'
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    echo 'installing zsh extensions requirements'

    echo 'installing p10k'
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    echo 'installing autosuggestions'
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    echo 'checking if thefuck is already installed'
    if ! [ -x "$(command -v thefuck)" ]; then
        echo 'thefuck is already installed'
    else    
        echo 'installing thefuck'
        brew install thefuck
    fi

    echo 'checking if fzf is already installed'
    if ! [ -x "$(command -v fzf)" ]; then
        echo 'fzf is already installed'
    else
        echo 'installing fzf'
        brew install fzf
        $(brew --prefix)/opt/fzf/install
    fi
        
}

function link_dotfiles {
    ln -s $cwd/.bash_logout ~/.bash_logout
    ln -s $cwd/.bashrc ~/.bashrc
    ln -s $cwd/.gitconfig ~/.gitconfig
    ln -s $cwd/.p10k.zsh ~/.p10k.zsh
    ln -s $cwd/.profile ~/.profile
    ln -s $cwd/.tmux.conf ~/.tmux.conf
    ln -s $cwd/.zshrc ~/.zshrc
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