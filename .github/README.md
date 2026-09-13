# dotfiles

Arch Linux + [Omarchy](https://omarchy.org/)（Hyprland）環境の設定ファイル。

[ArchWiki のドットファイル管理](https://wiki.archlinux.jp/index.php/%E3%83%89%E3%83%83%E3%83%88%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB)にある **bare リポジトリ方式** で管理している。シンボリックリンクや専用ツールは使わず、`$HOME` をそのまま作業ツリーにする。

## 仕組み

| 項目 | 値 |
| --- | --- |
| Git ディレクトリ | `~/.dotfiles`（bare リポジトリ） |
| 作業ツリー | `~`（`$HOME`） |
| 操作コマンド | `config`（`~/.bashrc` で定義したエイリアス） |
| リモート | `git@github.com:yuuxyu/dotfiles.git` |
| ブランチ | `main` |

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

- `status.showUntrackedFiles no` を設定しているので、ホーム内の未登録ファイルは `config status` に出ない。**新しいファイルは明示的に `config add` しない限り管理対象にならない。**
- `~/.gitignore` には `.dotfiles` だけを書いている。新しいマシンで checkout するときに、リポジトリ自身を追跡してしまう事故を防ぐため。
- この README は、ホームに `README.md` を散らかさないよう `~/.github/README.md` に置いている（GitHub はここにある README もトップに表示する）。

## 日常の使い方

```bash
config status                              # 変更の確認
config diff                                # 差分を見る
config add -u                              # 登録済みファイルの変更をすべてステージ
config commit -m "hypr: キーバインド追加"
config push

config add ~/.config/foo/config            # 新しいファイルを管理対象に追加
config rm --cached ~/.config/foo/config    # 管理対象から外す（ファイルは残る）
config ls-files                            # 管理しているファイルの一覧
```

> [!WARNING]
> `config add .` や `config add -A` は使わないこと。ホーム全体（ブラウザのプロファイル、SSH 鍵、トークンなど）がステージされる。ファイルは必ず個別に指定する。

## 新しいマシンへの導入

```bash
git clone --bare git@github.com:yuuxyu/dotfiles.git $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
config config status.showUntrackedFiles no
config checkout
```

`checkout` で既存ファイル（Omarchy が生成した `~/.bashrc` など）と衝突した場合は、退避してからやり直す。

```bash
mkdir -p ~/.dotfiles-backup
config checkout 2>&1 | grep -E '^\s+\S' | awk '{print $1}' \
  | xargs -I{} sh -c 'mkdir -p ~/.dotfiles-backup/$(dirname {}) && mv ~/{} ~/.dotfiles-backup/{}'
config checkout
```

その後に `source ~/.bashrc` するか、シェルを開き直す。

## 管理しているもの

| 分類 | パス |
| --- | --- |
| シェル | `.bashrc`, `.bash_profile`, `.XCompose`, `.config/starship.toml` |
| 開発ツール | `.config/git/config`, `.config/mise/config.toml`, `.config/lazygit/`, `.config/opencode/`, `.config/herdr/`, `.claude/settings.json` |
| エディタ | `.config/nvim/`（LazyVim）, `.config/zed/` |
| ターミナル | `.config/alacritty/`, `.config/ghostty/`, `.config/kitty/`, `.config/foot/`, `.config/tmux/` |
| デスクトップ | `.config/hypr/`, `.config/autostart/`, `.config/mimeapps.list`, `.config/user-dirs.dirs`, `.config/gtk-3.0/bookmarks`, `.config/fontconfig/`, `.config/wireplumber/` |
| Omarchy | `.config/omarchy/shell.json`, `extensions/`, `defaults/`, 自作の `hooks/` |
| 日本語入力 | `.config/fcitx5/config`, `profile`, `conf/*.conf` |
| その他 | `.config/btop/btop.conf`, `.config/xournalpp/`, `.config/chrome-flags.conf`, `.config/chromium-flags.conf` |

## 管理しないもの

| 対象 | 理由 |
| --- | --- |
| `~/.ssh`, `~/.claude.json`, `~/.codex`, `~/.claude/`（`settings.json` 以外） | 秘密鍵・トークン・履歴を含む |
| `.config/google-chrome`, `.config/chromium` などブラウザのプロファイル | 巨大で、Cookie などの個人データを含む |
| `.config/mozc/` | ユーザー辞書がバイナリで、個人的な単語を含む |
| `.config/systemd/user/`, `.config/btop/themes/current.theme` | Omarchy が作る `/usr/lib` や state へのシンボリックリンク |
| `.config/omarchy/**/*.sample`, `.config/omarchy/branding/` | Omarchy が配布する雛形 |
| `~/.local/bin`, `~/.local/share/applications` | Omarchy がインストールするラッパーと Web アプリ |
| `.config/fcitx5/conf/cached_layouts`, `.config/go/telemetry`, `dconf`, `pulse` | 自動生成・キャッシュ |

## Omarchy との付き合い方

- Hyprland の設定は `hyprland.lua` で Omarchy のデフォルト（`/usr/share/omarchy/default/hypr/`）を読み込み、その後に `monitors.lua` / `input.lua` / `bindings.lua` / `looknfeel.lua` / `autostart.lua` で上書きする構成。**Omarchy 本体のファイルは直接編集せず、このリポジトリ側で上書きする。**
- テーマは Omarchy が `~/.local/state/omarchy/current/theme` への symlink で切り替えるので、テーマ由来のファイルは管理しない。
- Omarchy のアップデートで `~/.config` 配下が書き換わることがある。アップデート後は `config status` / `config diff` で差分を確認し、取り込むか戻すかを決める（戻すなら `config restore <path>`）。

## 注意事項

- コミット前に `config diff --cached` で秘密情報が含まれていないか確認する。
- マシン固有の値（`hypr/monitors.lua` のモニター構成など）は別のマシンで調整が必要。
- `.config/nvim/lazy-lock.json` はプラグインのバージョンを固定するためにコミットしている。
