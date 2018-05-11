#export M2_HOME=/Applications/maven
#export SVN_EDITOR=/usr/local/bin/vim
#export CATALINA_HOME=/Applications/eclipse3.6_64bit/workspace3.6/apache-tomcat-7.0.23-src/output/build
#export CATALINA_HOME=/Applications/tomcat
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0_27-b07-395.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_25.jdk/Contents/Home

#PATH export PATH=/Applications/MAMP/Library/bin:$PATH

#Javaのバーション切り替え
export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8"`

#PosgreSql環境変数PGDATAの設定
export PGDATA=/usr/local/var/postgres
#

# /etc/profileのpath helperで設定されるようなのでいらないかもしれない
#PATH="$PATH:/usr/local/bin"

PATH="$PATH:/usr/local/sbin"

# PATH=$PATH:$M2_HOME/bin

PATH=${PATH}:${JAVA_HOME}/bin

PATH="$PATH:/usr/local/heroku/bin"

PATH=$PATH:$HOME/.nodebrew/current/bin

PATH="$PATH:/Applications/MacVim.app/Contents/bin"

export PATH

export NODE_PATH=/Users/teru1/.nodebrew/node/v6.11.1/lib/node_modules

# .bashrc を読み込む
test -r ~/.bashrc && . ~/.bashrc

