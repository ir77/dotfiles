# Xcodeにビルド時間を表示する
defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES

# スクリーンショットを英語に
defaults write com.apple.screencapture name ""

# Dock
defaults write com.apple.dock persistent-apps -array #Dock に標準で入っている全てのアプリを消す、Finder とごみ箱は消えない
defaults write com.apple.dock autohide -bool true
killall Dock

# keyboard
defaults write -g com.apple.keyboard.fnState -bool true

# finder
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder QuitMenuItem -bool true

# trackpad 
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Spotlight
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled"=1;"name"="APPLICATIONS";}' \
    '{"enabled"=1;"name"="MENU_CONVERSION";}' \
    '{"enabled"=1;"name"="MENU_EXPRESSION";}' \
    '{"enabled"=1;"name"="MENU_DEFINITION";}' \
    '{"enabled"=1;"name"="SYSTEM_PREFS";}' \
    '{"enabled"=1;"name"="BOOKMARKS";}' \
    '{"enabled"=1;"name"="MENU_OTHER";}' \
    '{"enabled"=0;"name"="MENU_SPOTLIGHT_SUGGESTIONS";}' \
    '{"enabled"=0;"name"="DOCUMENTS";}' \
    '{"enabled"=0;"name"="DIRECTORIES";}' \
    '{"enabled"=0;"name"="PRESENTATIONS";}' \
    '{"enabled"=0;"name"="SPREADSHEETS";}' \
    '{"enabled"=0;"name"="PDF";}' \
    '{"enabled"=0;"name"="MESSAGES";}' \
    '{"enabled"=0;"name"="CONTACT";}' \
    '{"enabled"=0;"name"="EVENT_TODO";}' \
    '{"enabled"=0;"name"="IMAGES";}' \
    '{"enabled"=0;"name"="MUSIC";}' \
    '{"enabled"=0;"name"="MOVIES";}' \
    '{"enabled"=0;"name"="FONTS";}' \
    '{"enabled"=0;"name"="SOURCE";}' \

## index再生成
killall mds 
sudo mdutil -i on /
sudo mdutil -E /

# バッテリーのパーセントを表示する
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Kill affected applications
for app in Finder Dock SystemUIServer; do killall "$app" >/dev/null 2>&1; done

