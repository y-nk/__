source ${HOME}/.shellrc
source ${HOME}/.secrets

bindkey -e

HISTFILE="${HOME}/.config/zsh/.zsh_history"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

setopt HIST_IGNORE_ALL_DUPS

setopt CORRECT
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

WORDCHARS=${WORDCHARS//[\/]}

zstyle ':zim:git' aliases-prefix 'g'
zstyle ':zim:input' double-dot-expand yes

ZIM_HOME="${__}/.zim"
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

fortune

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(mise activate zsh)"

# orbstack
source "$HOME/.config/.orbstack/shell/init.zsh"
