export M2_HOME=/Applications/maven
#export SVN_EDITOR=/usr/local/bin/vim
#export CATALINA_HOME=/Applications/eclipse3.6_64bit/workspace3.6/apache-tomcat-7.0.23-src/output/build
#export CATALINA_HOME=/Applications/tomcat
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0_27-b07-395.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_25.jdk/Contents/Home

#PATH export PATH=/Applications/MAMP/Library/bin:$PATH

#Javaのバーション切り替え
export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8"`
PATH=${JAVA_HOME}/bin:${PATH}

export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH=$M2_HOME/bin:$PATH
#export PATH=/Applications/MacVim.app/Contents/MacOS:$PATH

#rbenvのパス設定
#export PATH="$HOME/.rbenv/shims:$PATH"

#PosgreSql環境変数PGDATAの設定
export PGDATA=/usr/local/var/postgres

#eval "$(rbenv init -)"
#export PATH="$HOME/.nodebrew/current/bin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH

### Added by the Heroku Toolbelt
#export PATH="/usr/local/heroku/bin:$PATH"

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

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/teru1/.gvm/bin/gvm-init.sh" ]] && source "/Users/teru1/.gvm/bin/gvm-init.sh"

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
export PATH=$HOME/.nodebrew/current/bin:$PATH
