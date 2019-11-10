export ZSH="/Users/marc/.oh-my-zsh"
plugins=(git command-time)

source $ZSH/oh-my-zsh.sh
fpath+=${ZDOTDIR:-~}/.zsh_functions

alias zshrc="nvim ~/.zshrc"
alias lt="exa -T -a -l -L=3"
alias ls="exa"
alias ll="exa -l -a"
alias c="clear"
alias sl="say 'you are a moron'"



# Enable colors and change prompt:
autoload -U colors && colors


function prompt-length() {
  emulate -L zsh
  local COLUMNS=${2:-$COLUMNS}
  local -i x y=$#1 m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ));
    done
    local xy
    while (( y > x + 1 )); do
      m=$(( x + (y - x) / 2 ))
      typeset ${${(%):-$1%$m(l.x.y)}[-1]}=$m
    done
  fi
  echo $x
}

# Prints LEFT<spaces>RIGHT with enough spaces in the middle
# to fill a terminal line.
function fill-line() {
  emulate -L zsh
  local left_len=$(prompt-length $1)
  local right_len=$(prompt-length $2 9999)
  local pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1}))
  if (( pad_len < 1 )); then
    # Not enough space for the right part. Drop it.
    echo -E - ${1}
  else
    local pad=${(pl.$pad_len.. .)}  # pad_len spaces
    echo -E - ${1}${pad}${2}
  fi
}

# Sets PROMPT and RPROMPT.
function set-prompt() {
  emulate -L zsh
  local git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  git_branch=${${git_branch//\%/%%}/\\/\\\\\\}  # escape '%' and '\'

  
  local top_left='%F{magenta}%~%f'
  local top_right="%F{green}${git_branch}%f"
  #local bottom_left='%B%F{%(?.green.red)}%#%f%b '
  local bottom_left
  bottom_left='%B%F{%(?.green.red)}▶[%f%F{yellow}%n%f%F{green}@%f%F{blue}%M%f%F{%(?.green.red)}]%f%b '
  local bottom_right='%F{yellow}%T%f'

  PROMPT=$'\n'"$(fill-line "$top_left" "$top_right")"$'\n'$bottom_left
  RPROMPT=$bottom_right
}

setopt noprompt{bang,subst} prompt{cr,percent,sp}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set-prompt

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


setopt debugbeforecmd
#trap 'if ! whence -w "$ZSH_DEBUG_CMD" >& /dev/null; then special_function $ZSH_DEBUG_COMMAND;fi' DEBUG
trap 'if ! whence -w "$ZSH_DEBUG_CMD" >& /dev/null; then;fi' DEBUG
exec 2> >(grep -v "command not found" > /dev/stderr)


# If command execution time above min. time, plugins will not output time.
ZSH_COMMAND_TIME_MIN_SECONDS=2

# Message to display (set to "" for disable).
ZSH_COMMAND_TIME_MSG="Execution time: %s"

# Message color.
ZSH_COMMAND_TIME_COLOR="cyan"

# Load zsh-syntax-highlighting; should be last.
source /usr/local/Cellar/zsh-syntax-highlighting/0.6.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

