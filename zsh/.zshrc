eval "$(starship init zsh)"

# alias ripgrep to grep
# https://news.ycombinator.com/item?id=22281977
alias grep="rg"
# alias grep="rg -uuu"

# alias bat to cat
alias cat="bat"
# alias cat="bat --paging=never"

# nvim editor quick access
n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }
# alias for nvim
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
# tfswitch for terraform
export PATH="$PATH:$HOME/bin"

# kubecolor
alias kubectl="kubecolor"

# ls with color
alias ls='ls -G'

# kubectl prompt
autoload -U colors; colors
source /opt/homebrew/etc/zsh-kubectl-prompt/kubectl.zsh

# enable git completion
autoload -Uz compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# https://unix.stackexchange.com/questions/568907/why-do-i-lose-my-zsh-history
HISTFILE=$HOME/.zsh_history
HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# claude-monitor
export PATH="$HOME/.local/bin:$PATH"

# claude code
export PATH="$PATH:$HOME/.claude/local"
# To stop Claude getting confused about which directory it should be running commands in
export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1

# llm tools
export EDITOR="nvim"

# # fzf init
# if command -v fzf &> /dev/null; then
#   source <(fzf --zsh)
# fi

if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# zoxide init
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# File system, fzf and eza aliases
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# zoxide required
alias cd="zd"
zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~ && return
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf " \U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}

# z
# . /opt/homebrew/etc/profile.d/z.sh
