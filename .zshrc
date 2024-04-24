# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
export PATH=/usr/local/bin:${PATH}

export PATH=/Users/tsuda/temp/module/p2netex-thumbnail-generator/bin:${PATH}

autoload -Uz colors
colors
#PROMPT="%{$fg[green]%}%m%(!.#.$) %{$reset_color%}"
local p_cdir="%B%F{blude}[%~]%f%b"$'\n'
#local p_cdir="%B%F{blue}[%~]%f%b"
#local p_info="%n@%m"
PROMPT=" $p_cdir$p_info "

source "/usr/local/opt/zsh-git-prompt/zshrc.sh"
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=" )"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%{ %G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[magenta]%}%{x%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%{+%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}%{-%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}%{+%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"
#RPROMPT='$(git_super_status)'
PROMPT="$PROMPT"'$(git_super_status) > '

#autoload -U compinit; compinit
#zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
#                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin \
#                             /usr/local/git/bin
#
#
if [ -e /usr/local/share/zsh-completions ]; then
	fpath=(/usr/local/share/zsh-completions $fpath)
fi

autoload -U compinit
compinit -u


#compdef _blade blade 
#function _blade {
#  local -a cmds
#  if (( CURRENT == 2 ));then
#    cmds=('init' 'update' 'upgrade' 'commit')
#    _describe -t commands "subcommand" cmds
#  else
#    _files
#  fi
#
#  return 1;
#}

echo "read zshrc"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
