#!/bin/sh
# dotfiles の symlink を $HOME と ~/.vim に張る。何度実行しても同じ状態になる
#   - リンク先が既に symlink なら張り直す
#   - 普通のファイルやディレクトリがあれば <名前>.backup.<日時> に退避してから張る
set -eu

DOTFILES=$(cd "$(dirname "$0")" && pwd)
STAMP=$(date +%Y%m%d%H%M%S)

# $1: dotfiles 内のパス, $2: リンクを置く場所
link() {
  src="$DOTFILES/$1"
  dest="$2"
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    mv "$dest" "$dest.backup.$STAMP"
    echo "退避: $dest -> $dest.backup.$STAMP"
  fi
  # -n を付けないと、dest がディレクトリへの symlink のときにその中へリンクを作ってしまう
  ln -sn "$src" "$dest"
  echo "link: $dest -> $src"
}

for f in .vimrc .ideavimrc .tmux.conf .vrapperrc .bash_profile .bashrc .tigrc; do
  link "$f" "$HOME/$f"
done

mkdir -p "$HOME/.vim"
for d in colors rc plugin autoload; do
  link "$d" "$HOME/.vim/$d"
done
