alias cl='clear'
alias doc='cd ~/Documents'
alias pathc='pwd | pbcopy'
alias loglocal='less /private/var/log/p2netex/tomcat/p2net/app/System.out'
alias p='cd ~/project'
#export M2_HOME=/Applications/maven
#export SVN_EDITOR=/usr/local/bin/vim
#export CATALINA_HOME=/Applications/eclipse3.6_64bit/workspace3.6/apache-tomcat-7.0.23-src/output/build
#export CATALINA_HOME=/Applications/tomcat
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0_27-b07-395.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_25.jdk/Contents/Home

#PATH export PATH=/Applications/MAMP/Library/bin:$PATH

[ -f $(brew --prefix)/etc/bash_completion ] && . $(brew --prefix)/etc/bash_completion

#Javaのバーション切り替え
#export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8"`
#export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "11"`
#export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "14"`
#export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.7"`

#export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export JAVA_HOME=`/usr/libexec/java_home -v 11`
#export JAVA_HOME=`/usr/libexec/java_home -v 14`
#export JAVA_HOME=`/usr/libexec/java_home -v 1.7`

#PosgreSql環境変数PGDATAの設定
export PGDATA=/var/lib/p2netex/postgresql/p2net/data
export CATALINA_HOME=/Applications/apache-tomcat-8.5.34
export CATALINA_BASE=/Applications/apache-tomcat-8.5.34

PATH=""

PATH=/opt/X11/bin:${PATH}
PATH=/sbin:${PATH}
PATH=/usr/sbin:${PATH}
PATH=/bin:${PATH}
PATH=/usr/bin:${PATH}
PATH=/usr/local/bin:${PATH}
PATH=$JAVA_HOME/bin:${PATH}

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

PATH=/Applications/Wireshark.app/Contents/MacOS:${PATH}
PATH=/Users/tsuda/p2netex-traversal-console/bin:${PATH}
#PATH=/usr/local/bin:${PATH}
PATH=/Users/tsuda/p2netex-builder/bin:${PATH}
PATH=$HOME/.nodebrew/current/bin:${PATH}
PATH=/usr/local/opt/postgresql@9.6/bin:${PATH}
PATH=/Users/tsuda/temp/module/p2netex-thumbnail-generator/bin:${PATH}
PATH=/Users/tsuda/project/p2net/p2netex-application/bin:${PATH}

PATH=/Users/tsuda/.deno/bin:${PATH}

export PATH
export MANPATH
#

if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="$(brew --prefix bash-git-prompt)/share"
  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
fi

#各オプションの内容
#git/git-prompt.sh at master · git/git に記されている各オプションの内容をまとめます。
#
#GIT_PS1_SHOWDIRTYSTATE
#空以外の値を設定にすることで有効になる。
#unstaged な変更がある時に (*) を、 staged な変更がある時に (+) を、プロンプトのブランチ名の右に表示する。
#GIT_PS1_SHOWSTASHSTATE
#空以外の値を設定にすることで有効になる。
#stashed がある時に ‘$’ を、プロンプトのブランチ名の右に表示する。
#GIT_PS1_SHOWUNTRACKEDFILES
#空以外の値を設定にすることで有効になる。
#untracked files がある時に ‘%’ を、プロンプトのブランチ名の右に表示する。
#GIT_PS1_SHOWUPSTREAM
#HEAD とその upstream の間の差分をみたい時に、 GIT_PS1_SHOWUPSTREAM="auto" と設定する。
#"<" は upstream よりも遅れている状態であることを示す。
#">" は upstream よりも進んでいる状態であることを示すã
#"<>" は upstream から分岐した状態であることを示す。
#"=" は upstream と一致している状態であることを示す。
#半角スペース区切りでさらに設定することができる。
#git/git-prompt.sh at 041fe8fc83770f95b09db4aa9d9b3783789eab08 · git/git
#GIT_PS1_SHOWCOLORHINTS
#空以外の値を設定にすることで有効になる。
#現在の状態を色付けして表示する。
#__git_ps1 を PROMPT_COMMAND または precmd で使用した場合のみ有効となる。
#PROMPT_COMMAND とは？
#＊PS1 の前に PROMPT_COMMAND の内容が実行される。*
#各コマンド実行後に PROMPT_COMMAND の内容が毎回実行される。

#PROMPT_COMMAND='__git_ps1 "\u:\W" "\\\$ "'
PROMPT_COMMAND='__git_ps1 "\W" "\\\$ "'
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_HIDE_IF_PWD_IGNORED=true
GIT_PS1_SHOWUPSTREAM="auto"


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#export PYENV_ROOT=~/.pyenv
#export PATH="${PYENV_ROOT}/shims:${PATH}"

##pyenvとpyenv-virtualenvで補完がきくようにする
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# poetryをパスに通す
export PATH="~/.poetry/bin:${PATH}"

GOPATH=$HOME/project/go
export PATH="${GOPATH}/bin:${PATH}"
export GOROOT="$(brew --prefix golang)/libexec"

echo "read bashrc"

export BASH_SILENCE_DEPRECATION_WARNING=1
. "$HOME/.cargo/env"


#nodev17以上でのでのエラー対応
#export NODE_OPTIONS=--openssl-legacy-provider
export NODE_OPTIONS=

# Fig post block. Keep at the bottom of this file.
#[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && . "$HOME/.fig/shell/bashrc.post.bash"

# Fig post block. Keep at the bottom of this file.
#[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

export PIPENV_VENV_IN_PROJECT=1

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
# gh command completion
eval "$(gh completion -s bash)"
