source ~/.shellrc

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval "$(fnm env --use-on-cd)"
. "$HOME/.cargo/env"
