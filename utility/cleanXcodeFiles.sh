#!/bin/sh
# 動作確認: 2018/02/26, Xcode9.2, macOS Sierra 10.12.6
# [Xcode 8.2] 年末なので Xcode まわりの不要ファイルを一掃してみた ｜ Developers.IO
# https://dev.classmethod.jp/smartphone/remove-xcode8-related-unnecessary-files/

# 実機デバッグを行うために必要なファイルを削除
rm -r ~/Library/Developer/Xcode/iOS\ DeviceSupport/*

# プロジェクトのインデックスやビルド時の生成物、ログなどを削除
rm -r ~/Library/Developer/Xcode/DerivedData/*

# Product -> Archive 実行時に作成されるファイルを削除
rm -r ~/Library/Developer/Xcode/Archives/*

# シミュレータ上にインストールしたアプリや設定を削除
# simctl: シミュレータの制御ツール
xcrun simctl erase all

# SDK のドキュメント等を削除
rm -r ~/Library/Developer/Shared/Documentation/DocSets/*

# デバイスログを削除
rm -r ~/Library/Developer/Xcode/iOS\ Device\ Logs/*
