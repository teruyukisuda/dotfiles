# .bashrcを読み込む
if [ -f "${HOME}/dotfiles/.bashrc" ]; then
    . "${HOME}/dotfiles/.bashrc"
fi

complete -C /opt/homebrew/bin/terraform terraform
