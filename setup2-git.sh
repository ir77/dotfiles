echo 'git settings'
git config --global push.default simple # git pushでcurrentブランチだけアップデートする
git config --global --add push.autoSetupRemote true
git config --global pull.rebase false
git config --global core.editor vim
git config --global core.quotepath false # git statusで日本語文字の文字化けを防ぐ
git config --global init.defaultBranch main

git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global merge.conflictStyle zdiff3
git config --global delta.navigate true
git config --global delta.side-by-side true
git config --global delta.line-numbers true
git config --global delta.hunk-header-style "omit"
git config --global delta.color-moved true

echo 'git config --global user.name "user"'
echo 'git config --global user.email "email"'

