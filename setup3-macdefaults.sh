# keyrepeatやtrackpadの速度をいじる行為はバグったときに面倒なことになるので手動で行う

# Xcodeにビルド時間を表示する
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

# スクリーンショット
## 英語に
defaults write com.apple.screencapture name ""
## 保存先の変更
echo 'defaults write com.apple.screencapture location path'

# Dock
defaults write com.apple.dock persistent-apps -array #Dock に標準で入っている全てのアプリを消す、Finder とごみ箱は消えない
defaults write com.apple.dock autohide -bool true
killall Dock

# finder
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder QuitMenuItem -bool true

# trackpad 
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# status item
# https://zenn.dev/usagimaru/articles/9c4f45b0f3c906
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 9
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 6

## index再生成
killall mds 
sudo mdutil -i on /
sudo mdutil -E /

# バッテリーのパーセントを表示する
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Kill affected applications
for app in Finder Dock SystemUIServer; do killall "$app" >/dev/null 2>&1; done

