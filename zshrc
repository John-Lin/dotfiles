(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# alias ripgrep to grep
# https://news.ycombinator.com/item?id=22281977
alias grep="rg"
# alias grep="rg -uuu"

# alias bat to cat
alias cat="bat"
# alias cat="bat --paging=never"

# vim to nvim
alias vim="nvim"
alias vi="nvim"
alias vimdiff='nvim -d'
# kubectl editor
export KUBE_EDITOR="nvim"

# Homebrew install golang
export GOPATH=$HOME/go
export GOROOT=/opt/homebrew/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# alias python
alias python='python3'
# ctags
alias ctags='/opt/homebrew/bin/ctags'

# sops key file
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"

# ntoken file path
export NTOKEN_FILE="$HOME/.config/zms/.ntoken"

# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# z
. /opt/homebrew/etc/profile.d/z.sh

# kubecolor
alias kubectl="kubecolor"

# ls with color
alias ls='ls -G'

# kubectl prompt
autoload -U colors; colors
source /opt/homebrew/etc/zsh-kubectl-prompt/kubectl.zsh
# default kubectl prompt
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

# enable git completion
autoload -Uz compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# https://unix.stackexchange.com/questions/568907/why-do-i-lose-my-zsh-history
HISTFILE=/Users/al02464443/.zsh_history
HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
