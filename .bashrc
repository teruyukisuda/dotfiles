alias cl='clear'
alias doc='cd ~/Documents'
alias pathc='pwd | pbcopy'
alias loglocal='less /private/var/log/p2netex/tomcat/p2net/app/System.out'
alias p='cd ~/project'
alias i='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias ls='ls --color=always'
alias gls='gls --color=always'
alias ll='ls -lFa'

# bash-completion (Homebrew)
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# PATH設定を一度だけ構築（重複を避ける）
# 基本的なシステムパス
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

# fnmの設定を追加
eval "$(fnm env --use-on-cd)"

# その他のツール
PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
PATH="$HOME/.claude/local:$PATH"

export PATH

# git-prompt.sh (__git_ps1) の表示設定
#   * 未ステージの変更  + ステージ済み  $ stash あり  % 未追跡ファイル  < > <> = upstream との差
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


# プロンプト: カレントディレクトリ (赤) とブランチ (緑) を表示して改行
export PS1='\[\033[1;31m\]\w\[\033[1;32m\]$(__git_ps1)\[\033[00m\]\n\$ '


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# pipenvで仮想環境をプロジェクト配下に作る
export PIPENV_VENV_IN_PROJECT=1

export BASH_SILENCE_DEPRECATION_WARNING=1

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
