# チュートリアル: Claude Code に書かせた変更をレビューする

`vim-review-workflow.md` に書いた操作を、練習用のリポジトリで最初から最後まで一度通す。
題材は 20 行ほどのシェルスクリプト。所要時間は 40 分程度。

前半（1〜7 節）は、Claude Code にコミットさせずに書かせた変更を、ステータス画面で仕分けてコミットする。
後半（8 節）は、Claude Code にブランチでコミットまでさせた変更を、`review main...` で一覧から読む。

前提は次の 3 つ。

- `vim-review-workflow.md` の 6 章の手順で設定を反映してある（`vim` を起動して `:Git` と `:Review` が動けばよい）
- `claude` コマンドが動く
- tmux の中で作業している（2 節の `cw` が tmux のウィンドウを作るため。tmux の外なら先に `tmux` と打つ）

この文書の画面例は、文書を書くときに用意したサンプルの変更で取ったもの。
Claude Code に書かせた結果は毎回違うので、自分の画面に読み替えながら進める。
「何を見てどう判断するか」が同じであれば、行番号やハッシュや中身が違っていてよい。

---

## 1. 練習用のリポジトリを作る

```
mkdir -p ~/tmp/review-tutorial
cd ~/tmp/review-tutorial
git init -b main
```

README を作って最初のコミットにする。

```
cat > README.md <<'EOF'
# todo.sh

テキストファイル 1 つで管理する TODO スクリプト。

    ./todo.sh add 牛乳を買う
    ./todo.sh list
EOF
git add README.md
git commit -m "README を追加"
```

次に本体を作る。`add` と `list` だけの状態。

```
cat > todo.sh <<'EOF'
#!/bin/bash
# 1 行 1 件のテキストファイルで管理する簡単な TODO
set -eu

FILE="${TODO_FILE:-$HOME/.todo.txt}"
touch "$FILE"

case "${1:-}" in
  add)
    shift
    echo "$*" >> "$FILE"
    ;;
  list)
    nl -w2 -s'. ' "$FILE"
    ;;
  *)
    echo "usage: todo.sh add <text> | list" >&2
    exit 1
    ;;
esac
EOF
chmod +x todo.sh
```

動くことを確かめてからコミットする。`TODO_FILE` を指定しないと `~/.todo.txt` に書くので、
練習中は一時ファイルを指定する。

```
TODO_FILE=/tmp/tutorial.todo ./todo.sh add aaa
TODO_FILE=/tmp/tutorial.todo ./todo.sh add bbb
TODO_FILE=/tmp/tutorial.todo ./todo.sh list
```

```
 1. aaa
 2. bbb
```

```
git add todo.sh
git commit -m "todo.sh: add と list"
```

---

## 2. Claude Code に書かせる

```
cw ~/tmp/review-tutorial
```

tmux に新しいウィンドウができる。左ペインがシェル、右ペインで `claude` が起動する。
ウィンドウ名はディレクトリ名（`review-tutorial`）になる。

右ペインの Claude Code に次のように頼む。

```
todo.sh に次の 2 つを追加してください。
- done <n> : n 番目の項目を削除する
- help     : 使い方を表示する。引数なしのときも同じ内容を出す
動作確認用の test.sh も作ってください。
README.md は変えないでください。コミットはしないでください。
```

前半はステータス画面で仕分ける練習なので、「コミットはしない」と書く。

終わったら左ペインで変更の範囲を見る。

```
git status --short
git diff --stat
```

```
 M todo.sh
?? test.sh
 todo.sh | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)
```

`M` は追跡済みファイルの変更、`??` は git がまだ知らない新規ファイル。
この文書のサンプルでは、todo.sh に次の 4 か所の変更が入っている。

1. `touch "$FILE"` の前に `mkdir -p "$(dirname "$FILE")"` が足されている（頼んでいない変更）
2. `usage()` 関数が足されている
3. `case` に `done)` と `help|-h|--help|"")` の分岐が足されている
4. `*)` の中身が `usage` の呼び出しに変わっている

Claude Code に書かせた結果にも、たいてい「頼んでいない変更」が 1 つか 2 つ混ざる。
それを見つけて落とすのがレビューの仕事のひとつ。

---

## 3. ステータス画面を開く

左ペインで、変更のあるリポジトリを確認する。`changed` と `review` の既定の探索先は
`~/project/iso` なので、ここでは引数で `~/tmp` を渡す。

```
changed ~/tmp
```

```
   2  /Users/tsuda/tmp/review-tutorial
```

数字は `git status --porcelain` の行数、つまり変更のあるファイル数。

```
review ~/tmp
```

fzf の画面が出る。左に候補のリポジトリ、右のプレビューに `git status --short` と
`git diff --stat HEAD` が出る。候補が 1 つなので `Enter` で決定する。
今いるリポジトリを直接開くなら `review .` でもよい。

vim がステータス画面で起動する。

```
Head: main
Help: g?

Untracked (1)
? test.sh

Unstaged (1)
M todo.sh
```

`test.sh` は新規ファイルなので Untracked 欄に、変更した `todo.sh` は Unstaged 欄に出る。

---

## 4. 差分を展開して読む

`]c` を押す。最初は Untracked 欄の `? test.sh` の行に止まる。新規ファイルは差分を展開できないので、6 節で扱う。

もう一度 `]c` を押すと、`todo.sh` の差分がその場に展開され、カーソルが最初のハンクの見出し（`@@` の行）に移る。

```
Unstaged (1)
M todo.sh
@@ -3,8 +3,19 @@
 set -eu
 
 FILE="${TODO_FILE:-$HOME/.todo.txt}"
+mkdir -p "$(dirname "$FILE")"
 touch "$FILE"
 
+usage() {
+  cat >&2 <<USAGE
+usage: todo.sh <command>
+  add <text>  項目を追加する
+  list        項目を番号付きで表示する
+  done <n>    n 番目の項目を削除する
+  help        この使い方を表示する
+USAGE
+}
+
 case "${1:-}" in
   add)
     shift
@@ -13,8 +24,19 @@ case "${1:-}" in
   list)
     nl -w2 -s'. ' "$FILE"
     ;;
+  done)
+    n="${2:-}"
+    if ! [[ "$n" =~ ^[0-9]+$ ]]; then
+      echo "done: 番号を指定してください" >&2
+      exit 1
+    fi
+    sed -i "${n}d" "$FILE"
+    ;;
+  help|-h|--help|"")
+    usage
+    ;;
   *)
-    echo "usage: todo.sh add <text> | list" >&2
+    usage
     exit 1
     ;;
 esac
```

- `@@ -3,8 +3,19 @@` で始まる行がハンクの見出し。ここから次の `@@` までが 1 ハンク
- 行頭が `+` の行は追加、`-` の行は削除、空白の行は前後の文脈（変わっていない行）
- 1 つ目のハンクには `mkdir` と `usage()` が入っている。2 つの変更が近い（6 行以内）ので、git が 1 つのハンクにまとめている

`]c` `[c` でハンクを行き来しながら最後まで目を通し、何が変わったかを把握する。判断はまだしない。
`=` を押すと展開した差分を閉じられる（もう一度押すと開く）。

---

## 5. ハンクを仕分ける

変更のかたまりごとに、採用・却下・手直しのどれかを決めて処理する。
ステージ済みかどうかが「レビュー済みかどうか」の印になる。

### 5-1. ハンクの一部だけを採用する: ビジュアル選択して `-`

1 つ目のハンクのうち、`usage()` 関数は採用したいが、`mkdir` の行は頼んでいない変更なので落としたい。
1 つのハンクに両方が入っているので、`usage()` の部分だけを選んでステージする。

1. `+usage() {` の行にカーソルを置く
2. `V` で行単位のビジュアル選択を始め、`}` の次の空行（`+` だけの行）まで `j` で広げる
3. `-` を押す

選んだ行だけが index に入り、画面の下に Staged 欄ができる。Unstaged 側の差分からは `usage()` が消え、
`mkdir` の行がひとつのハンクとして残る。

```
Unstaged (1)
M todo.sh
@@ -3,6 +3,7 @@
 set -eu
 
 FILE="${TODO_FILE:-$HOME/.todo.txt}"
+mkdir -p "$(dirname "$FILE")"
 touch "$FILE"
 
 usage() {
@@ -22,8 +24,19 @@ case "${1:-}" in
（略）

Staged (1)
M todo.sh
```

ハンク全体を採用するなら、選択せずにハンクの中で `-` を押せばよい。

### 5-2. 却下する: `X`

`+mkdir` の行にカーソルを置いて `X` を押す。そのハンクの変更が作業ツリーから消える。
画面の下に元に戻すためのコマンドが出る。

```
To restore, :Gsplit todo.sh|Gread d447895e31d
```

間違えて消したときは、このコマンドをそのまま実行すれば戻せる。後から見るときは `:messages`。

### 5-3. 手直しして採用する: `o` で開いて直す

残っているハンクは `done)` `help` の分岐と、`*)` の中身の変更。`done)` の部分を読む。

```
  done)
    n="${2:-}"
    if ! [[ "$n" =~ ^[0-9]+$ ]]; then
      echo "done: 番号を指定してください" >&2
      exit 1
    fi
    sed -i "${n}d" "$FILE"
    ;;
```

数字かどうかは見ているが、範囲は見ていない。`./todo.sh done 99` のように存在しない番号を渡しても
`sed` は何もせずに成功扱いになる。これは直してから採用する。

Unstaged 欄の `M todo.sh` の行にカーソルを置いて `o` を押す。ステータス画面の上に `todo.sh` が開く。
`sed -i` の行の上に次の 4 行を足す。

```
    if [ "$n" -lt 1 ] || [ "$n" -gt "$(wc -l < "$FILE")" ]; then
      echo "done: $n 番目の項目はありません" >&2
      exit 1
    fi
```

`:w` で保存し、`:q` でステータス画面に戻る。ステータス画面は自動で更新され、足した 4 行が差分に入っている。

残りの `help` の分岐と `*)` の変更はそのまま採用でよい。ハンクごとに `-` を押してもよいが、
Unstaged に残っている変更は全部採用なので、`M todo.sh` の行で `-` を押してファイルごとステージする。

Unstaged 欄が消え、`todo.sh` は Staged 欄だけに残る。これが「レビュー済み」の状態。

Claude が書いた部分と自分が足した部分は、この時点で区別がなくなる。
後から「どこを直したか」を残したいなら、手直しを別のコミットに分ける。この練習ではまとめてよい。

---

## 6. 新規ファイルを読んでステージする

カーソルを Untracked 欄の `? test.sh` の行に置き、`o` を押す。画面が上下に割れて上に `test.sh` が開く。

```
#!/bin/bash
# todo.sh の簡単な動作確認
set -eu
cd "$(dirname "$0")"
export TODO_FILE="$(mktemp)"
trap 'rm -f "$TODO_FILE"' EXIT

./todo.sh add aaa
./todo.sh add bbb
./todo.sh add ccc
./todo.sh done 2
[ "$(./todo.sh list | wc -l | tr -d ' ')" = 2 ]
./todo.sh list | grep -q ccc
echo ok
```

新規ファイルは差分がない（全部が追加）ので、全体を普通に読む。
`TODO_FILE` を一時ファイルに向けていて、終了時に消していること、`done` の後の件数を見ていることを確認する。

読み終えたら `:q` でその窓を閉じ、ステータス画面に戻る。
`? test.sh` の行で `-` を押すとステージされ、Staged 欄に `A test.sh` が並ぶ。

```
Staged (2)
A test.sh
M todo.sh
```

`Enter` ではなく `o` を使うのは、`Enter` だとステータス画面のウィンドウ自体がそのファイルに置き換わるから。
置き換わってしまったら `:Gedit :` で同じウィンドウにステータス画面を戻せる。

---

## 7. コミットする

ステータス画面で `cc` を押す。上にコミットメッセージ用のバッファが開く。

```
    1
    2 # Please enter the commit message for your changes. Lines starting
    3 # with '#' will be ignored, and an empty message aborts the commit.
    4 #
    5 # On branch main
    6 # Changes to be committed:
    7 #       new file:   test.sh
    8 #       modified:   todo.sh
```

1 行目にメッセージを書いて `:wq`。

```
todo.sh: done と help を追加
```

コミットが作られ、ステータス画面は `Head: main` と `Help: g?` だけになる。
`:qa` で vim を終了する。

左ペインで確認する。

```
changed ~/tmp          # 何も出なければ全部コミット済み
git log --oneline
git show --stat HEAD   # delta で色付きで出る
./test.sh              # ok と出る
```

`git show HEAD` で全体を見ると、Claude が書いた部分と 5-3 で足した部分が 1 つのコミットに入っていて、
`mkdir` の行は入っていない。

---

## 8. 後半: コミット済みの変更を一覧で読む

ここからは、Claude Code にブランチで実装からコミットまで任せた変更を読む。

### 8-1. ブランチを切ってコミットまでさせる

左ペインでブランチを切る。

```
git switch -c feature/clear
```

右ペインの Claude Code に頼む。

```
todo.sh に clear コマンド（全項目を消す）を追加し、test.sh にそのテストを足してください。
todo.sh と test.sh は別々のコミットにしてください。
```

終わったら左ペインで履歴を見る。

```
git log --oneline
```

```
04e732c test.sh: clear のテストを追加
887772e todo.sh: clear を追加
d473092 todo.sh: done と help を追加
5d71790 todo.sh: add と list
2c887c3 README を追加
```

上の 2 つが今回 Claude Code が積んだコミット。

### 8-2. 一覧を開く

```
review main...
```

`main...` は「main から分岐した後、今のブランチで積んだ分」という意味。
vim が起動し、1 つ目のタブに一覧が出る。

```
Review: main...
Enter: ファイル行はそのタブへ / コミット行はコミットを開く   gt gT: タブ移動   ,gq: 全部閉じる

Commits (2)
  04e732c test.sh: clear のテストを追加
  887772e todo.sh: clear を追加

Files (2)
  M  test.sh  +2 -0
  M  todo.sh  +3 -0
```

- Commits 欄で、どんなコミットが積まれたかがわかる
- Files 欄で、範囲全体でどのファイルが何行変わったかがわかる
- タブは一覧のほかに、ファイルごとに 1 つずつ（ここでは 2 つ）できている。画面上端のタブ行で確かめられる

カーソルは Files の 1 行目（`test.sh`）にある。

### 8-3. ファイルの差分を読む

`test.sh` の行で `Enter` を押す。`test.sh` の差分タブへ移る。
左が分岐点の `test.sh`、右がブランチの最新の `test.sh` で、どちらも読み取り専用。

`]c` で差分の位置へ飛ぶ。`./todo.sh clear` と `[ -z "$(./todo.sh list)" ]` の 2 行が足されている。

読み終えたら `1gt` で一覧に戻り、`todo.sh` の行で `Enter`。`gt` で次のタブへ進んでもよい。

`todo.sh` では `case` に `clear)` の分岐が足されている。ここで、`usage()` の説明文に `clear` が入っていないことに気づく。
`help` で出る使い方に新しいコマンドが載らないので、直したい。

### 8-4. コミットの単位で読む

`1gt` で一覧に戻り、Commits 欄の `887772e todo.sh: clear を追加` の行で `Enter` を押す。
上にコミットの画面が開く。

```
tree f4aada5b585a1a409d8dbb3b383ffe432d91c5fb
parent d473092595a3babb87d8138471dab0ffa2ec83fb
author ...

todo.sh: clear を追加

diff --git a/todo.sh b/todo.sh
index 88bebe1..b226d03 100755
--- a/todo.sh
+++ b/todo.sh
@@ -35,6 +35,9 @@ case "${1:-}" in
     fi
     sed -i "${n}d" "$FILE"
     ;;
+  clear)
+    : > "$FILE"
+    ;;
   help|-h|--help|"")
     usage
     ;;
```

このコミットでの変更がこれで全部であること、つまり `usage()` を直し忘れていることが確かめられる。
`gq` でコミットの画面を閉じる。

### 8-5. 直して元のコミットに混ぜる

`,gq` で一覧と差分タブを全部閉じる。普通のファイルのウィンドウが無いので、空のバッファになる。

`:e todo.sh` で開き、`usage()` の `help` の行の上に 1 行足して `:w`。

```
  clear       項目を全部消す
```

`,gs` でステータス画面を開き、`M todo.sh` の行で `-` を押してステージする。

この直しは「todo.sh: clear を追加」のコミットに入っているべきものなので、そのコミットに混ぜる。

1. `,gl` でログ画面を開く
2. `todo.sh: clear を追加` の行にカーソルを置いて `cf` を押す。コマンドラインに
   `:Git commit --fixup=887772e...` が入るので `Enter`。`fixup! todo.sh: clear を追加` というコミットができる
3. `gq` でログ画面を閉じ、もう一度 `,gl` で開く。`todo.sh: clear を追加` の行で `rf` を押す。
   rebase が走り、`fixup!` コミットが元のコミットに混ざる

`rf` は履歴を書き換える。push 済みのコミットには使わない。

左ペインで確かめる。

```
git log --oneline -3
review main...
```

ハッシュは変わるが、コミットは 2 つのまま。一覧の Files 欄で `todo.sh` が `+4 -0` になり、
差分タブで `usage()` にも `clear` の行が入っていることを確かめる。

新しいコミットとして残したい場合は、2〜3 の代わりにステータス画面で `cc` を押してコミットすればよい。

---

## 9. 片付ける

```
rm -rf ~/tmp/review-tutorial
rm -f /tmp/tutorial.todo
```

tmux のウィンドウは、両方のペインで `exit` するか、`tmux kill-window` で閉じる。

---

## 10. つまずきやすい点

- **`]c` が `? test.sh` の行で止まる。** 新規ファイルの行もハンクと同じく止まる。もう一度 `]c` を押すと次の差分へ進む。
- **ビジュアル選択の `-` で思ったより多く／少なくステージされた。** Staged 欄のファイルで `=` を押して差分を開き、
  余分な行をビジュアル選択して `-` を押すとアンステージに戻る。
- **`X` で消しすぎた。** 画面の下に出た `To restore, ...` のコマンドを実行する。流れてしまったら `:messages` で見る。
- **ステータス画面で `s` を押しても何も起きない。** この vimrc では fugitive の `s` を外してある。ステージは `-`。
- **`Enter` で開いたらステータス画面が消えた。** `:Gedit :` で戻る。次からは `o` で開く。
- **一覧で `Enter` を押してもタブが移らない。** カーソルがファイルかコミットの行にない。見出しや空行では何も起きない。
  名前だけを変えたファイル（`R` で `+0 -0`）は差分タブが作られないので、その旨のメッセージが出る。
- **`review main...` で「差分がありません」と出る。** ブランチを切り忘れて main の上でコミットしている。
  `git log --oneline` で確かめ、その場合は `review HEAD~2..` のように範囲をコミット数で指定する。
- **`changed` にリポジトリが出続ける。** コミット後も untracked ファイルが残っていると数えられる。
  Claude が作った一時ファイルや生成物がないか `git status --short` で見る。
- **サンプルの `sed -i "${n}d"` について。** この書き方は GNU sed のもので、macOS 標準の BSD sed では
  `sed -i '' "${n}d"` と書く必要がある。この環境では Homebrew の gnu-sed が PATH の先頭にあるので動く。
  Claude Code が書いたコードが「自分の環境では動くが他では動かない」典型で、
  レビューで `./test.sh` を実行して確かめる理由になる。
