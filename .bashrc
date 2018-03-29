#alias ls='ls -laF'
alias desk='cd /Users/teru1/Desktop'
alias download='cd /Users/teru1/Downloads'
alias conf='vim ~/.bash_profile'
alias doc='cd ~/Documents'
alias vag='cd ~/Documents/VagrantVM'
alias httpdconf='cd /usr/local/etc/apache2'
alias phpini='cd /usr/local/etc/php/5.5/'
alias workspace='cd /Applications/eclipse4.4/workspace'
alias pVim='cd ~/Documents/practicalVim'
alias jq='cd ~/Documents/jQueryCookBook'
alias vim="reattach-to-user-namespace vim"
alias sed="gsed"
alias awk="gawk"
alias grep="ggrep"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

### Ctrl+wでスラッシュ区切りで削除したい
stty werase undef
bind '"\C-w": unix-filename-rubout'

#ターミナルからでもMacVimを起動する
# alias mvim='env_LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/MacVim'

#隠しファイルを表示するエイリアス設定
alias showdot='~/Documents/myTools/showdot.sh'

#隠しファイルを隠すエイリアス設定
alias hidedot='~/Documents/myTools/hidedot.sh'

#KobitoDBのファイルをDropBoxにバックアップする
alias kobitoCp='~/Documents/myTools/kobitoCp.sh'

#tmuxの自動起動
#if [ -z "$PS1" ]; then return ; fi

#if [ -z $TMUX ] ; then
#    if [ -z `tmux ls` ] ; then
#        tmux
#    else
#        tmux attach
#    fi
#fi

stty stop undef
stty start undef

# ↓これのことhttp://qiita.com/ksato9700/items/36a06de1c080167e1538
#test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/teru1/.gvm/bin/gvm-init.sh" ]] && source "/Users/teru1/.gvm/bin/gvm-init.sh"

### Added by the Heroku Toolbelt
#export PATH="/usr/local/heroku/bin:$PATH"

