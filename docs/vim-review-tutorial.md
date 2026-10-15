# チュートリアル: 小さなスクリプトを Claude Code に書かせてレビューする

`vim-review-workflow.md` に書いた操作を、練習用のリポジトリで最初から最後まで一度通す。
題材は 20 行ほどのシェルスクリプト。所要時間は 30 分程度。

前提は次の 3 つ。

- `vim-review-workflow.md` の 4 章の手順で設定を反映してある（`vim` を起動して `:Git` が動けばよい）
- `claude` コマンドが動く
- tmux の中で作業している（2 節の `cw` が tmux のウィンドウを作るため。tmux の外なら先に `tmux` と打つ）

この文書の画面例は、文書を書くときに用意したサンプルの変更で撮ったもの。
Claude Code に書かせた結果は毎回違うので、自分の画面に読み替えながら進める。
「何を見てどう判断するか」が同じであれば、行番号や中身が違っていてよい。

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
git log --oneline
```

```
d108b50 todo.sh: add と list
861d67d README を追加
```

コミットを 2 つに分けたのには理由がある。gitgutter は fugitive が開く「HEAD 時点のファイル」に対して
HEAD の 1 つ前のコミットとの差分を記号で出す仕様で、コミットが 1 つしかないと
「`g:gitgutter_diff_base (...^) is invalid`」という警告が出る。実害はないが、初回に見ると驚くので避けた。

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

「コミットはしない」は毎回書く。コミットされてしまうと、これから使う差分の仕組みに変更が乗らない。

終わったら左ペインで変更の範囲を見る。

```
git status --short
git diff --stat
```

```
 M todo.sh
?? test.sh
 todo.sh | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)
```

`M` は追跡済みファイルの変更、`??` は git がまだ知らない新規ファイル。
この文書のサンプルでは、todo.sh に次の 4 か所の変更が入っている。

1. `touch "$FILE"` の前に `mkdir -p "$(dirname "$FILE")"` が足されている（頼んでいない変更）
2. `usage()` 関数が足されている
3. `case` に `done)` と `help|-h|--help)` の分岐が足されている
4. `*)` の中身が `usage` の呼び出しに変わっている

Claude Code に書かせた結果にも、たいてい「頼んでいない変更」が 1 つか 2 つ混ざる。
それを見つけて落とすのがレビューの仕事のひとつ。

---

## 3. レビューを開く

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

vim が起動し、2 つのタブができる。

- タブ 1: ステータス画面
- タブ 2: `todo.sh` の左右差分

```
    1 Head: main
    2 Help: g?
    3
    4 Untracked (1)
    5 ? test.sh
    6
    7 Unstaged (1)
    8 M todo.sh
```

`test.sh` は新規ファイルなので差分タブにはならず、ここの Untracked 欄にだけ出る。
これは 6 節で扱う。

---

## 4. 差分タブの見方

`gt` でタブ 2 へ移る。

```
  +   5 FILE="${TODO_FILE:-$HOME/.todo.txt}"  |      5 FILE="${TODO_FILE:-$HOME/.todo.txt}"
        --------------------------------------|  +   6 mkdir -p "$(dirname "$FILE")"
  +   6 touch "$FILE"                         |      7 touch "$FILE"
  +   7                                       |      8
        --------------------------------------|  +   9 usage() {
        --------------------------------------|  +  10   cat >&2 <<EOF
        （中略）                                |
  +  16   *)                                  |     40   *)
  +  17     echo "usage: todo.sh add ..." >&2 |  ~  41     usage
  +  18     exit 1                            |     42     exit 1
```

- 左が HEAD（最後のコミット）時点の `todo.sh`、右が今の `todo.sh`。カーソルは右にある
- 右側の行番号の左にある `+` `~` が gitgutter の記号。`+` は追加行、`~` は変更行、`_` はその行の下で行が削除された位置
- 左側の全行に `+` が付いているが、これは「HEAD のコミットでこのファイルがまるごと追加された」ことを
  示しているだけで、今回のレビューとは関係ない。左側の記号は見なくてよい
- `------` の行は、左右の行を揃えるために vim が入れている詰め物

右側で `]c` を押すと次の差分へ、`[c` で前の差分へ飛ぶ。`]h` `[h` も、左右差分のタブの中では
同じ動きになる（gitgutter が diff モードでは `]c` `[c` に切り替える仕様）。

まずは `]c` を押しながら最後まで目を通し、何が変わったかを把握する。判断はまだしない。

---

## 5. ハンクを仕分ける

変更のかたまり（ハンク）ごとに、採用・却下・手直しのどれかを決めて処理する。
ステージ済みかどうかが「レビュー済みかどうか」の印になる。

### 5-1. 却下する: `,hu`

`gg` で先頭に戻り、`]h` で最初のハンクへ。サンプルでは 6 行目の `mkdir -p ...` に止まる。

`,hp` を押すと、画面の下にこのハンクの差分だけがプレビューで出る。

```
    1 +mkdir -p "$(dirname "$FILE")"
```

これは頼んでいない変更で、`~/.todo.txt` のように親ディレクトリが必ずあるパスでは意味がない。却下する。

`,hu` を押す。右ウィンドウからその行が消え、ステータス行に `[+]`（未保存）が付く。
`,hu` はバッファを書き換えるだけで、ファイルには保存しない。`:w` で保存する。

保存すると右側の記号と左右の差分表示が更新され、`mkdir` の行は左右どちらにもなくなる。

### 5-2. 採用する: `,hs`

`]h` で次のハンクへ。`usage()` 関数の先頭に止まる。

さっきのプレビューを閉じていなければ、`]h` のたびにプレビューの中身がそのハンクに変わる。
左右差分で十分に読めるなら `:pclose` でプレビューを閉じてよい。

関数の中身を読む。使い方の文面がそのまま `help` の出力になるので、コマンド名と説明が合っているかを見る。
問題なければ `,hs` を押す。ハンクが index に書き込まれ（ステージ）、右側の `+` が消える。
`,hs` は git に直接書くので `:w` はいらない。

### 5-3. 手直しして採用する

`]h` で次のハンクへ。`done)` と `help|-h|--help)` の分岐に止まる。

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

右ウィンドウで `sed -i` の行の上に次の 4 行を足す。

```
    if [ "$n" -lt 1 ] || [ "$n" -gt "$(wc -l < "$FILE")" ]; then
      echo "done: $n 番目の項目はありません" >&2
      exit 1
    fi
```

`:w` で保存する。足した行はもとのハンクと地続きなので、ひとつのハンクとして扱われる。
カーソルをハンクの中に置いたまま `,hs` でステージする。

Claude が書いた部分と自分が足した部分は、この時点で区別がなくなる。
後から「どこを直したか」を残したいなら、`,hs` の前に `git diff` を delta で眺めるか、
手直しを別コミットに分ける。この練習ではまとめてよい。

### 5-4. 残りを片付ける

`]h` で次へ。`*)` の中身が `usage` に変わった 1 行のハンク。`help` と同じ文面を出すだけなので採用、`,hs`。

右側の記号が全部消えたら todo.sh のレビューは終わり。
左右の差分表示は残るが、それは左が HEAD だから。index にはもう反映されている。

---

## 6. 新規ファイルを読んでステージする

`gT` でタブ 1（ステータス画面）に戻る。

```
    4 Untracked (1)
    5 ? test.sh
    6
    7 Staged (1)
    8 M todo.sh
```

`todo.sh` が Staged に移り、Unstaged 欄が消えている。これが「レビュー済み」の状態。

カーソルを `? test.sh` の行に置き、`o` を押す。画面が上下に割れて上に `test.sh` が開く。

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
    4 Staged (2)
    5 A test.sh
    6 M todo.sh
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

`git show HEAD` で全体を見ると、Claude が書いた部分と 5-3 で足した部分が 1 つのコミットに入っている。

---

## 8. 2 周目（任意）: 同じリポジトリに追加で書かせる

右ペインの Claude Code に続きを頼む。

```
test.sh に、存在しない番号で done したとき（./todo.sh done 99）に
exit 1 になることを確認するケースを足してください。コミットはしないでください。
```

今度は左ペインで `vim` を起動して `,gD` を押す。1 周目と違い、左は HEAD ではなく index になる。
今回はまだ何もステージしていないので、どちらでも見える内容は同じ。

操作は 5 節と同じ。`]h` `,hp` `,hs` `,hu` で仕分け、`,gs` でステータス画面を出し、
Unstaged が残っていないことを確かめて `cc`。

コミットを Claude に任せるなら、ステージ済みの内容だけをコミットするよう伝える。

```
ステージ済みの内容だけをコミットしてください。メッセージは「test.sh: done の範囲外チェックを追加」で。
```

---

## 9. 片付ける

```
rm -rf ~/tmp/review-tutorial
rm -f /tmp/tutorial.todo
```

tmux のウィンドウは、両方のペインで `exit` するか、`tmux kill-window` で閉じる。

---

## 10. つまずきやすい点

- **`,hu` のあと `:w` を忘れる。** ステータス画面の Unstaged に残り続ける。差分タブに戻って `:w`。
- **`,hs` `,hu` `,hp` を押しても何も起きない。** カーソルがハンクの上にない。右側の記号列が付いている行に置く。
  HEAD と比較するタブ（`review` `,gH`）では `]h` がステージ済みの行でも止まるので、
  記号のない行に止まったときは何もせず次へ進む。
- **ステータス画面で `s` を押しても何も起きない。** このvimrc では fugitive の `s` を外してある。ステージは `-`。
- **`Enter` で開いたらステータス画面が消えた。** `:Gedit :` で戻る。次からは `o` で開く。
- **`changed` にリポジトリが出続ける。** コミット後も untracked ファイルが残っていると数えられる。
  Claude が作った一時ファイルや生成物がないか `git status --short` で見る。
- **サンプルの `sed -i "${n}d"` について。** この書き方は GNU sed のもので、macOS 標準の BSD sed では
  `sed -i '' "${n}d"` と書く必要がある。この環境では Homebrew の gnu-sed が PATH の先頭にあるので動く。
  Claude Code が書いたコードが「自分の環境では動くが他では動かない」典型で、
  レビューで `./test.sh` を実行して確かめる理由になる。
