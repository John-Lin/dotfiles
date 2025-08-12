# https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#how-do-i-initialize-direnv-when-using-instant-prompt
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
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# alias python3
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
# default kubectl prompt
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

# enable git completion
autoload -Uz compinit && compinit

# History control for zsh
# https://unix.stackexchange.com/questions/568907/why-do-i-lose-my-zsh-history
HISTFILE=$HOME/.zsh_history

# Append history lines to the history file instead of overwriting it
setopt append_history
# Ignore commands that start with a space in the history
setopt hist_ignore_space
# Ignore duplicate commands in the history
setopt hist_ignore_all_dups
# Number of history entries kept in memory
HISTSIZE=500000
# Number of history entries saved to the history file
SAVEHIST=500000
# Write each command to the history file immediately after it is executed
setopt inc_append_history
# Share history between all running zsh sessions in real time
setopt share_history

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
