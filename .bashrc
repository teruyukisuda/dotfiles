# Fig pre block. Keep at the top of this file.
#[[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.bash"
alias cl='clear'
alias doc='cd ~/Documents'
alias pathc='pwd | pbcopy'
alias loglocal='less /private/var/log/p2netex/tomcat/p2net/app/System.out'
alias p='cd ~/project'
alias i='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias ls='ls --color=always'
alias gls='gls --color=always'
alias ll='ls -lFa'
#export M2_HOME=/Applications/maven
#export SVN_EDITOR=/usr/local/bin/vim
#export CATALINA_HOME=/Applications/eclipse3.6_64bit/workspace3.6/apache-tomcat-7.0.23-src/output/build
#export CATALINA_HOME=/Applications/tomcat
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0_27-b07-395.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_25.jdk/Contents/Home

#PATH export PATH=/Applications/MAMP/Library/bin:$PATH

#[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
#[ -f /opt/homebrew/etc/bash_completion ] && . /opt/homebrew/etc/bash_completion
#[ -f $(/opt/homebrew/bin/brew --prefix)/etc/bash_completion ] && . $(/opt/homebrew/bin/brew --prefix)/etc/bash_completion
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"


# PATH設定を一度だけ構築（重複を避ける）
# # 基本的なシステムパス
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# sdkmanのjavaが自動的にPATHに追加される
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Homebrew
PATH="/opt/homebrew/bin:$PATH"

# GNU tools (Homebrew)
PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH" 
PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"

# Volta (Node.js管理)
#export VOLTA_HOME="$HOME/.volta"
#PATH="$VOLTA_HOME/bin:$PATH"

# fnmの設定を追加
eval "$(fnm env --use-on-cd)"

# その他のツール
PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
PATH="$HOME/.claude/local:$PATH"

export PATH
#

#if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
#  __GIT_PROMPT_DIR="$(brew --prefix bash-git-prompt)/share"
#  source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
#fi

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
#PROMPT_COMMAND='__git_ps1 "\W" "\\\$ "'
#GIT_PS1_SHOWDIRTYSTATE=true
#GIT_PS1_SHOWSTASHSTATE=true
#GIT_PS1_SHOWUNTRACKEDFILES=true
#GIT_PS1_SHOWCOLORHINTS=true
#GIT_PS1_HIDE_IF_PWD_IGNORED=true
#GIT_PS1_SHOWUPSTREAM="auto"

#source /opt/homebrew/Cellar/git/2.37.3/etc/bash_completion.d/git-prompt.sh
#source /opt/homebrew/Cellar/git/2.37.3/etc/bash_completion.d/git-completion.bash

#PROMPT_COMMAND='__git_ps1 "\W" "\\\$"'↲
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_HIDE_IF_PWD_IGNORED=true
GIT_PS1_SHOWUPSTREAM="auto"

# Gitの補完と プロンプト用スクリプトの読み込み
if [ -f "/opt/homebrew/etc/bash_completion.d/git-prompt.sh" ]; then
    . "/opt/homebrew/etc/bash_completion.d/git-prompt.sh"
fi
if [ -f "/opt/homebrew/etc/bash_completion.d/git-completion.bash" ]; then
    . "/opt/homebrew/etc/bash_completion.d/git-completion.bash"
fi

# wfxコマンドの補完
if [[ -f "/usr/local/share/bash-completion/completions/wfx" ]]; then
  source "/usr/local/share/bash-completion/completions/wfx"
fi


# 環境変数PS1の変更
#export PS1='\[\033[1;34m\]\W\[\033[1;31m\]$(__git_ps1)\[\033[00m\] \$ '
#export PS1='\w\[\033[1;32m\]$(__git_ps1)\[\033[00m\]\n\$ '
#export PS1='\[\033[38;5;141m\]\w\[\033[00m\]$(__git_ps1)\[\033[00m\]\n\$ '
export PS1='\[\033[1;31m\]\w\[\033[1;32m\]$(__git_ps1)\[\033[00m\]\n\$ '


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# export PYENV_ROOT=~/.pyenv
# export PATH="${PYENV_ROOT}/shims:${PATH}"
#
##pyenvとpyenv-virtualenvで補完がきくようにする
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
#if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# poetryをパスに通す
#export PATH="~/.poetry/bin:${PATH}"

# pipenvで仮想環境をプロジェクト配下に作る
export PIPENV_VENV_IN_PROJECT=1

export BASH_SILENCE_DEPRECATION_WARNING=1
#. "$HOME/.cargo/env"


#nodev17以上でのでのエラー対応
#export NODE_OPTIONS=--openssl-legacy-provider

# Fig post block. Keep at the bottom of this file.
#[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && . "$HOME/.fig/shell/bashrc.post.bash"

# Fig post block. Keep at the bottom of this file.
#[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"

# gh command completion
eval "$(gh completion -s bash)"

# コマンド履歴の戻りを有効にするにはsttyで設定されているctrl+sを無効にすることで
# ctrl+sでできるようにする
stty stop undef


# uv
export PATH="/Users/tsuda/.local/bin:$PATH"

# =============================================================================
# fzf / Claude Code レビュー用
# =============================================================================
# fzf のキーバインド (Ctrl-R 履歴, Ctrl-T ファイル, Alt-C ディレクトリ移動)
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# Claude Code に書かせたコードをリポジトリ単位でレビューするためのヘルパー
#   changed [root]  : 未コミットの変更があるリポジトリを一覧する (既定: ~/project/iso)
#   review  [root]         : 変更のあるリポジトリを fzf で選び、vim でステータス画面を開く
#   review  <repo>         : そのリポジトリのステータス画面を開く (未コミットの変更が無ければ何もしない)
#   review  [repo] <範囲>  : 範囲 (main... / A..B / abc123^! など) の差分を vim の :Review で開く
#                            repo を省略すると今いるリポジトリ
#   cw      [dir]   : tmux に「左 vim / 右 claude」の作業ウィンドウを作る
REVIEW_ROOT="${REVIEW_ROOT:-$HOME/project/iso}"

__review_repos() {
  local root="${1:-$REVIEW_ROOT}" d n
  for d in "$root"/*/ "$root"/worktrees/*/; do
    [ -e "$d/.git" ] || continue
    n=$(git -C "$d" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    [ "$n" -gt 0 ] && printf '%s\t%s\n' "$n" "${d%/}"
  done | sort -rn
}

changed() {
  __review_repos "$1" | awk -F'\t' '{ printf "%4d  %s\n", $1, $2 }'
}

review() {
  local dir=""
  if [ -n "$1" ] && [ -d "$1" ]; then
    dir=$1
    shift
  fi

  # 範囲の指定がある: そのリポジトリで :Review {範囲} を開く
  if [ $# -gt 0 ]; then
    local top
    top=$(git -C "${dir:-.}" rev-parse --show-toplevel 2>/dev/null) || {
      echo "review: 範囲を見るときは、リポジトリを指定するかリポジトリの中で実行してください" >&2
      return 1
    }
    cd "$top" || return
    vim -c "Review $*"
    return
  fi

  # 範囲の指定がない: 未コミットの変更をステータス画面で見る
  local repo
  if [ -n "$dir" ] && [ -e "$dir/.git" ]; then
    if [ -z "$(git -C "$dir" status --porcelain 2>/dev/null)" ]; then
      echo "review: 未コミットの変更がありません: $dir" >&2
      return 1
    fi
    repo=$dir
  else
    repo=$(__review_repos "$dir" | fzf --with-nth=2.. --delimiter='\t' \
            --preview 'git -C {2} status --short && echo && git -C {2} diff --stat HEAD' \
            --preview-window=right:55%) || return
    repo=${repo#*	}
  fi
  cd "$repo" || return
  vim -c 'Review'
}

cw() {
  local dir="${1:-$PWD}"
  dir=$(cd "$dir" && pwd) || return
  tmux new-window -c "$dir" -n "$(basename "$dir")" \; \
       split-window -h -c "$dir" 'claude' \; \
       select-pane -L
}
