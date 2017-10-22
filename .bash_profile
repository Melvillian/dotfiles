# git completion
source ~/.git-completion.bash

# helps with differentiating output of `ls`
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# color terminal line to make it visually distinct from stdout
export PS1="\[\e[31;1m\]\h:\W \u\$> \[\e[0m\]"

# use non-Applie supplied version of git
export PATH=/usr/local/git/bin:$PATH

export EDITOR=/usr/bin/vim

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH=/usr/local/bin:/Library/Frameworks/Python.framework/Versions/2.7/bin:/Users/alex/Servers/tomcat-7.0.40/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin:/usr/texbin

# set github shortcuts if they haven't already been set
CONFIG_NOT_SET=$(git config --get alias.co)
if [ -z "${CONFIG_NOT_SET}" ]; then
        if [ -z "$1" ]; then
        echo "Usage: source ~/.bash_profile <GitHub email>"
        echo -e "\naborting..."
        return
    fi
        git config --global user.name "Alex Melville"
        git config --global user.email "$1"
        git config --global alias.co checkout
        git config --global alias.b branch
        git config --global alias.ci commit
        git config --global alias.s status
fi

export EDITOR=/usr/bin/vim

export PATH=/usr/local/sbin:$PATH
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# racer env var
export RUST_SRC_PATH=${HOME}/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src

# Alias for easily copying current directory path to clipboard
alias getpath='echo -n $PWD|pbcopy|echo "current path copied to clipboard"'

# Alias for my aws box
alias awssh_micro_playground="ssh -i ~/.ssh/unspendable-unspents-instance.pem ubuntu@ec2-34-213-73-124.us-west-2.compute.amazonaws.com"
alias awssh_bitcoind_1="ssh -i ~/.ssh/unspendable-unspents-instance.pem ubuntu@ec2-52-27-170-165.us-west-2.compute.amazonaws.com"
alias awssh_bitcoind_2="ssh -i ~/.ssh/unspendable-unspents-instance.pem ubuntu@ec2-35-164-86-105.us-west-2.compute.amazonaws.com"

export NVM_DIR="/Users/alex/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# use rusti from any directory
alias rusti="rustup run nightly-2016-08-01 ~/.cargo/bin/rusti"

# parity bitcoin
alias pbitcoin="/Users/alex/Desktop/CodingFolder/parity-bitcoin/target/debug/pbtc"

alias copy_dctrl_fobtap="scp  -i ~/.ssh/unspendable-unspents-instance.pem configuration.js COPYING README.md bountyChecker.js dispense.js fobtap.service index.js package.json tap.js vend.js  ubuntu@ec2-34-213-73-124.us-west-2.compute.amazonaws.com:~/dev/dctrl-fobtap/"

# used to easily source .bash_profile after updating, so I don't have to create a new terminal window
alias sourceb="source ~/.bash_profile"
alias vimb="vim ~/.bash_profile"
source /Users/alex/.bashrc

# access .vimrc
alias vimv="vim ~/.vim/vimrc"

#### https://github.com/BitGo/bitgo-onboarding/blob/master/Yubikey-SSH.md ####

# If connected locally
if [ -z "$SSH_TTY" ]; then

    # setup local gpg-agent with ssh support and save env to fixed location
    # so it can be easily picked up and re-used for multiple terminals
    envfile="$HOME/.gnupg/gpg-agent.env"
    if [[ ! -e "$envfile" ]] || ( \
           # deal with changed socket path in gnupg 2.1.13
           [[ ! -e "$HOME/.gnupg/S.gpg-agent" ]] && \
           [[ ! -e "/var/run/user/$(id -u)/gnupg/S.gpg-agent" ]]
       );
    then
        killall gpg-agent
        gpg-agent --daemon --enable-ssh-support > $envfile
    fi

    # Get latest gpg-agent socket location and expose for use by SSH
    eval "$(cat "$envfile")" && export SSH_AUTH_SOCK

    # Wake up smartcard to avoid races
    gpg --card-status > /dev/null 2>&1

fi

# If running remote via SSH
if [ ! -z "$SSH_TTY" ]; then
    # Copy gpg-socket forwarded from ssh to default location
    # This allows local gpg to be used on the remote system transparently.
    # Strongly discouraged unless GPG managed with a touch-activated GPG
    # smartcard such as a Yubikey 4.
    # Also assumes local .ssh/config contains host block similar to:
    # Host someserver.com
    #     ForwardAgent yes
    #     StreamLocalBindUnlink yes
    #     RemoteForward /home/user/.gnupg/S.gpg-agent.ssh /home/user/.gnupg/S.gpg-agent
    if [ -e $HOME/.gnupg/S.gpg-agent.ssh ]; then
        mv $HOME/.gnupg/S.gpg-agent{.ssh,}
    elif [ -e "/var/run/user/$(id -u)/gnupg/S.gpg-agent" ]; then
        mv /var/run/user/$(id -u)/gnupg/S.gpg-agent{.ssh,}
    fi

    # Ensure existing sessions like screen/tmux get latest ssh auth socket
    # Use fixed location updated on connect so in-memory location always works
    if [ ! -z "$SSH_AUTH_SOCK" -a \
        "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent_sock" ];
    then
        unlink "$HOME/.ssh/agent_sock" 2>/dev/null
        ln -s "$SSH_AUTH_SOCK" "$HOME/.ssh/agent_sock"
    fi
    export SSH_AUTH_SOCK="$HOME/.ssh/agent_sock"
fi

# don't let tmux override syntax highlighting mechanism
# https://stackoverflow.com/questions/10158508/lose-vim-colorscheme-in-tmux-mode#10264470
alias tmux="tmux -2"

# use ripgrep for fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
bind -x '"\C-p": vim $(fzf);'

# source any machine-specific configs
source ~/.bash_profile.local
