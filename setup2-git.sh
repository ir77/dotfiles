echo 'git settings'
git config --global push.default matching
git config --global push.default simple # git pushでcurrentブランチだけアップデートする
git config --global core.editor vim
git config --global core.quotepath false # git statusで日本語文字の文字化けを防ぐ
git config --global init.defaultBranch main

echo 'git config --global user.name "user"'
echo 'git config --global user.email "email"'

