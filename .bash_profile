#export M2_HOME=/Applications/maven
#export SVN_EDITOR=/usr/local/bin/vim
#export CATALINA_HOME=/Applications/eclipse3.6_64bit/workspace3.6/apache-tomcat-7.0.23-src/output/build
#export CATALINA_HOME=/Applications/tomcat
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0_27-b07-395.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_25.jdk/Contents/Home

#PATH export PATH=/Applications/MAMP/Library/bin:$PATH

export PATH
export MANPATH

#Javaのバーション切り替え
export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8"`

#PosgreSql環境変数PGDATAの設定
export PGDATA=/usr/local/var/postgres
#

# /etc/profileのpath helperで設定されるようなのでいらないかもしれない
#PATH="$PATH:/usr/local/bin"

#PATH="$PATH:/usr/local/sbin"
#
## PATH=$PATH:$M2_HOME/bin
#
PATH=${PATH}:${JAVA_HOME}/bin
#
#PATH="$PATH:/usr/local/heroku/bin"
#
PATH=$PATH:$HOME/.nodebrew/current/bin
#
PATH="$PATH:/Applications/MacVim.app/Contents/bin"
#
#export PATH
#
#export NODE_PATH=/Users/teru1/.nodebrew/node/v6.11.1/lib/node_modules

#export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
# coreutils
PATH=/usr/local/opt/coreutils/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}
# ed
PATH=/usr/local/opt/ed/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/ed/libexec/gnuman:${MANPATH}
# findutils
PATH=/usr/local/opt/findutils/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/findutils/libexec/gnuman:${MANPATH}
# sed
PATH=/usr/local/opt/gnu-sed/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/gnu-sed/libexec/gnuman:${MANPATH}
# tar
PATH=/usr/local/opt/gnu-tar/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/gnu-tar/libexec/gnuman:${MANPATH}
# grep
PATH=/usr/local/opt/grep/libexec/gnubin:${PATH}
MANPATH=/usr/local/opt/grep/libexec/gnuman:${MANPATH}


if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="$(brew --prefix bash-git-prompt)/share"
  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
fi

PROMPT_COMMAND='__git_ps1 "\u:\W" "\\\$ "'
#GIT_PS1_SHOWDIRTYSTATE=true
#GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
#GIT_PS1_HIDE_IF_PWD_IGNORED=true
#GIT_PS1_SHOWUPSTREAM="auto"

# .bashrc を読み込む
test -r ~/.bashrc && . ~/.bashrc

