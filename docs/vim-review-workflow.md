# vim + terminal で Claude Code の変更をレビューする

2026-10-14 に整備した構成のまとめ。IDE を使わず、vim / tmux / bash だけで
Claude Code に書かせたコードをリポジトリ単位で確認するための設定と手順を書く。

対象ファイルはすべて `~/dotfiles` にある。

| ファイル | 役割 |
|---|---|
| `.vimrc` | vim 本体の設定。末尾の「Git レビュー」節にレビュー用キーをまとめてある |
| `rc/dein.toml` | dein で管理するプラグイン一覧 |
| `.bashrc` | 末尾に fzf の初期化と `changed` / `review` / `cw` 関数 |
| `~/.gitconfig` | delta を git の pager にする設定（dotfiles 管理外） |

---

## 0. 最短の流れ

```
cw ~/project/iso/<repo>     # tmux に左シェル / 右 claude のウィンドウを作り、右で実装させる
changed                     # 変更が入ったリポジトリを一覧する
review                      # 1 つ選ぶと vim が開く。タブ 1 がステータス、タブ 2 以降が差分
```

vim の中では次を繰り返す。

- `gt` で次のファイル、`]h` で次のハンクへ進む
- 採用するハンクは `,hs`、戻すハンクは `,hu`、直すなら右側のウィンドウで編集して保存
- 新規ファイルはタブ 1（`,gs`）の Untracked に出る。`Enter` で開いて読み、`-` でステージ
- タブ 1 で未ステージが残っていなければ `cc` でコミット

`:qa` で抜けて `review` を再実行し、`changed` が空になるまで繰り返す。
各操作の意味は 2 章、手順の詳細は 3 章にある。

---

## 1. 今回やったこと

### 1-1. vimrc の修正

動いていなかった設定を直し、死んでいた設定を消した。596 行から 340 行になった。

**バグ修正**

- `sj` `sk` `so` などウィンドウ操作マップの末尾にあった `"コメント` が、マップ本体に
  含まれていた。`:map` の右辺では `"` はコメントにならない。コメントを行の外に出した。
  `so` は `|` で右辺が切れて `<C-w>_<C-w>` のまま次のキー待ちになっていたので、
  `<C-w>_<C-w><Bar>` に直した。
- `[q` が `:cprevi]us` と打ち間違っていた。`:cprevious` に修正。
- `<Space><CR>` の右辺にも `# コメント` が混入していた。
- `U` が存在しない `:Redo` を呼んでいた。`<C-r>` に変更。
- `~/.vim/plugin` の symlink が張られておらず `:CopyPath` `:CopyFileName`（`,cp` `,cf`）が
  使えなかった。`dotfilesLink.sh` と同じ symlink を張った。

**レビュー用途に合わせた変更**

- `set autochdir` を削除。開いたファイルの場所にカレントディレクトリが移ると、
  fugitive / fzf / quickfix のパスが狂うため。リポジトリルートに移りたいときは `,cd`。
- `set diffopt=vertical` は Vim 標準の値を上書きしていた。`+=` に変え、
  `internal,filler,closeoff,algorithm:histogram,indent-heuristic` を足した。
- `grepprg` を `rg --vimgrep` にした。`:grep` の結果が quickfix に入る。
- `set signcolumn=yes` と `set updatetime=100` を追加。gitgutter の記号が
  出たり消えたりして画面が横にずれるのを防ぎ、反映の遅延を 4 秒から 0.1 秒にした。

**削除した設定**

- vim-plug の区画。`~/.vim/plugged` が無く、ALE・vim-prettier・vimdoc-ja は
  一度もインストールされていなかった。必要になったら dein 側に追加する。
- NeoBundle、CtrlP、rsense、syntastic、quickrun のコメントアウト済み設定。
- unite.vim 用のマップとオートコマンド（プラグインごと削除）。

### 1-2. プラグインの入れ替え（rc/dein.toml）

| 操作 | プラグイン | 用途 |
|---|---|---|
| 追加 | `airblade/vim-gitgutter` | ハンクの表示、プレビュー、部分ステージ、取り消し |
| 追加 | `junegunn/fzf.vim` | `:Files` `:Buffers` `:Rg` `:GFiles?` `:Commits` `:BCommits` |
| 追加 | `rhysd/git-messenger.vim` | カーソル行の blame をポップアップ表示 |
| 削除 | `Shougo/unite.vim` | fzf.vim に置き換え |
| 削除 | `rking/ag.vim` | `ag` が未インストールで動いていなかった。`:Rg` に置き換え |

fzf 本体（`junegunn/fzf`）は dein ではなく Homebrew 版を使う。
`.vimrc` で `/opt/homebrew/opt/fzf` を runtimepath に足している。
fzf.vim は本体のバージョンと揃っている必要があり、brew で入れた実行ファイルと
同梱の vim プラグインを使えばずれない。

`tpope/vim-fugitive` は元から入っていたが、toml 内で Git レビュー用の区画に移した。

### 1-3. ターミナル側

- `brew install fzf git-delta` を実行した。
- `~/.gitconfig` に以下を追加した。既存の alias は変更していない。

```
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true
    side-by-side = true
    line-numbers = true
[diff]
    colorMoved = default
```

- `.bashrc` の末尾に fzf の初期化（`Ctrl-R` 履歴検索、`Ctrl-T` ファイル選択、
  `Alt-C` ディレクトリ移動）と、レビュー用のシェル関数を追加した。

---

## 2. レビューの手法と操作

### 2-1. 考え方

Claude Code が書いた変更は、コミットする前に次の 3 つに仕分ける。

1. そのまま採用する → ステージする
2. 手直しして採用する → vim で直してからステージする
3. 採用しない → ハンク単位で取り消す

ステージ済みかどうかが「レビュー済みかどうか」の印になる。
未ステージの変更がなくなったらそのリポジトリのレビューは終わり。

### 2-2. vim のキー

Leader は `,`。

**全体を見る（fugitive）**

| キー | 動作 |
|---|---|
| `,gs` | `:Git`。ステータス画面を開く |
| `,gD` | `:Git difftool -y`。未ステージの変更があるファイルを全部タブで開き、index と左右比較する |
| `,gH` | `:Git difftool -y HEAD`。ステージ済みも含めて HEAD との差分を全部タブで開く |
| `,gd` | `:Gvdiffsplit`。今のファイルだけ左右比較 |
| `,gq` | レビューで開いたタブとウィンドウを閉じて 1 つに戻す |
| `,gl` | 直近 50 件の `git log --oneline` |
| `,gb` | `:Git blame` |

ステータス画面（`,gs`）の中で使うキーは fugitive のもの。

| キー | 動作 |
|---|---|
| `=` | カーソル行のファイルの差分をその場で展開 / 折りたたみ |
| `dv` | カーソル行のファイルを左右差分で開く |
| `-` | ステージ / アンステージを切り替える |
| `X` | その変更を捨てる（ワークツリーの変更を破棄するので注意） |
| `cc` | コミットメッセージを書いてコミット |
| `)` `(` | 次 / 前のファイル・ハンクへ |
| `Enter` | カーソル行のファイルを開く。Untracked の新規ファイルを読むときはこれを使う |
| `gq` | ステータス画面を閉じる |

**新規ファイルについて。** `,gD` `,gH` `review` が開く差分タブは git が追跡しているファイルだけで、
新規ファイルは出てこない。新規ファイルはステータス画面の Untracked 欄に出るので、
`Enter` で開いて全体を読み、採用するなら `-` でステージする。

差分タブは左が比較元（`,gD` と `,gd` なら index、`,gH` と `review` なら HEAD）、右が作業ツリーのファイル。
コードを直すのは右のウィンドウで行う。左が index のときは左も編集でき、左で `:w` すると
その内容が index に書き込まれる（= ステージ）。左が HEAD のときは編集しても保存できない。
カーソルの初期位置は `,gD` `,gH` `review` では右、`,gd` では左になる。
Vim 標準の diff モードのキーが使える。

| キー | 動作 |
|---|---|
| `]c` `[c` | 次 / 前の差分へ |
| `gt` `gT` | 次 / 前のタブ（= 次のファイル）へ |
| `do` | 右のウィンドウで押すと、左（比較元）の内容を取り込む。つまりその差分を元に戻す |
| `dp` | 右のウィンドウで押すと、右の内容を左に送る。左が index のとき、続けて左で `:w` するとその差分がステージされる |

`do` と `dp` は差分 1 つ分に効く。ハンク単位の操作は下の gitgutter のキーでも同じことができる。

**ハンク単位で扱う（gitgutter）**

| キー | 動作 |
|---|---|
| `]h` `[h` | 次 / 前のハンクへ |
| `,hp` | ハンクの差分を下にプレビュー |
| `,hs` | ハンクをステージ。ビジュアル選択してから押すと選んだ行だけステージできる |
| `,hu` | ハンクを取り消してファイルを index の状態に戻す |
| `,hq` | 全ハンクを quickfix に流す。`]q` `[q` で巡回 |
| `,hf` | 変更のない行を折りたたんでハンクだけ表示 |
| `ih` `ah` | ハンクをテキストオブジェクトとして扱う（`dih` でハンク削除、`yah` でヤンクなど） |

ステージしたハンクは記号が消える。残っている記号が未レビュー分。

**探す（fzf.vim）**

| キー | 動作 |
|---|---|
| `,gf` | `:GFiles?`。変更のあるファイルを選んで開く |
| `,gc` | `:BCommits`。今のファイルのコミット履歴 |
| `,gC` | `:Commits`。リポジトリのコミット履歴 |
| `,gm` | カーソル行の blame をポップアップ表示 |
| `,uf` | `:Files` |
| `,ub` | `:Buffers`（`sb` も同じ） |
| `,um` | `:History`。最近開いたファイル |
| `,ua` | `:GFiles`。git 管理下のファイル |
| `,r` | `:Rg`。入力した文字列で全文検索 |
| `,R` | カーソル下の単語で `:Rg` |

fzf の画面では `Enter` で現在のウィンドウ、`Ctrl-T` でタブ、`Ctrl-X` で横分割、
`Ctrl-V` で縦分割に開く。`Ctrl-/` でプレビューの表示切り替え。

### 2-3. ターミナルのコマンド

delta を pager にしたので、`git diff` `git show` `git log -p` の出力が
左右並び・行番号付き・シンタックス色付きになる。

| 操作 | 内容 |
|---|---|
| `n` / `N` | pager 内で次 / 前のファイルへ |
| `git -c delta.side-by-side=false diff` | 画面が狭いときに上下並びで見る |
| `git add -p` | 対話的な部分ステージ。delta が色付けする |
| `tig status` / `tig` | 既存の `.tigrc` のまま。履歴をたどるときに使う |

---

## 3. Claude Code と組み合わせた運用

### 3-1. シェル関数

`.bashrc` 末尾に定義。探索先の既定値は `~/project/iso` 直下と `~/project/iso/worktrees` 直下。
環境変数 `REVIEW_ROOT` で変えられる。引数でも指定できる。

| 関数 | 動作 |
|---|---|
| `changed [root]` | 未コミットの変更があるリポジトリを、変更ファイル数の多い順に表示 |
| `review [root]` | 変更のあるリポジトリを fzf で選び、そこへ `cd` して vim を開く。プレビューに `git status --short` と `git diff --stat HEAD` が出る |
| `cw [dir]` | tmux に新しいウィンドウを作り、左ペインをシェル、右ペインで `claude` を起動する。ウィンドウ名はディレクトリ名 |

`review` で開く vim は次の状態になっている。

- タブ 1: `:Git` のステータス画面（untracked ファイルもここに出る）
- タブ 2 以降: HEAD と差分のあるファイルが 1 ファイル 1 タブで左右比較

### 3-2. 1 リポジトリの流れ

1. `cw ~/project/iso/<repo>` で作業ウィンドウを作る。右ペインの Claude Code に実装させる。
2. 実装が終わったら Claude に `git diff --stat` と `git status --short` を出させて変更範囲を把握する。
3. 差分タブを開く。どちらか一方でよい。
   - 左ペインで `review` を実行してこのリポジトリを選ぶ（HEAD との差分タブ + ステータス画面）
   - または左ペインで `vim` を起動し `,gD` を叩く（index との差分タブだけ）
4. タブを `gt` で送りながら差分を読む。直したい箇所は右のウィンドウで編集して保存する。
5. 採用するハンクは `,hs`、戻すハンクは `,hu`。
6. 新規ファイルはステータス画面（`review` ならタブ 1、`,gD` なら `,gs`）の Untracked 欄にある。
   `Enter` で開いて読み、採用するなら `-` でステージする。
7. ステータス画面で未ステージが残っていないことを確認し、`cc` でコミットする。
   Claude にコミットさせる場合は、ステージ済みの内容だけをコミットするよう伝える。

### 3-3. 複数リポジトリの流れ

1. Claude Code に複数リポジトリへ変更を入れさせる。
2. ターミナルで `changed` を実行し、どのリポジトリに変更が入ったかを確認する。
3. `review` で 1 つ選ぶと、差分タブとステータス画面が開いた状態で vim が起動する。
   3-2 の手順 4 から 7 を行う（手順 3 は `review` が済ませている）。
4. `:qa` で vim を抜け、`review` を再度実行して次のリポジトリへ。
5. `changed` の出力が空になったら全リポジトリのレビューが終わり。
   コミット済みでも untracked ファイルが残っていると `changed` に出続けるので、
   不要な生成物は削除するか `.gitignore` に入れる。

### 3-4. 注意点

- `X`（fugitive）と `,hu`（gitgutter）はワークツリーの変更を破棄する。元に戻せないので、
  迷う場合は `,hp` でプレビューしてから判断する。
- `,gD` は index との比較なので、ステージ済みのハンクは表示されない。
  ステージ後にもう一度全体を見たいときは `,gH` を使う。
- gitgutter の記号は、操作を止めてから `updatetime`（0.1 秒）後に更新される。
  古く見える場合は `:GitGutter` で更新できる。
- `review` と `changed` は `.git` が存在するディレクトリだけを対象にする。
  worktree（`.git` がファイル）も対象に入る。

---

## 4. 設定を反映する手順

新しい環境や、設定を変えた後に行う。

```
# dotfiles の symlink を張り直す
sh ~/dotfiles/dotfilesLink.sh

# vim のプラグインを入れる
# .vimrc の起動時に dein#check_install が未インストール分を検出して入れるので、
# vim を一度起動して :messages でエラーが無いことを確認する
vim

# シェル設定を読み直す
source ~/dotfiles/.bashrc
```

brew で入れたものは `fzf` と `git-delta`。`rg` と `tig` は以前から入っている。
