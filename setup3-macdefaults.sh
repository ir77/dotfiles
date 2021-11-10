# keyrepeatやtrackpadの速度をいじる行為はバグったときに面倒なことになるので手動で行う

# Xcodeにビルド時間を表示する
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

# スクリーンショットを英語に
defaults write com.apple.screencapture name ""

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

## index再生成
killall mds 
sudo mdutil -i on /
sudo mdutil -E /

# バッテリーのパーセントを表示する
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Kill affected applications
for app in Finder Dock SystemUIServer; do killall "$app" >/dev/null 2>&1; done

