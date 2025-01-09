(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

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
# alias for ghe
alias ghe='GH_HOST=git.linecorp.com gh'
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
