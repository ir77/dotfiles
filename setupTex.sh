ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew doctor
brew install caskroom/cask/brew-cask
brew cask install basictex
brew install nkf ghostscript

echo "export PATH=/usr/texbin:$PATH" >> ~/.bash_profile
source ~/.bash_profile

sudo tlmgr update --self --all
sudo tlmgr install ptex ptex2pdf jfontmaps jsclasses japanese-otf boxedminipage epsf c

brew cask install texshop

cat <<'_EOT_' >> ~/.bash_profile
	function tex(){
		FILESTRING=$1
		FILENAME=${FILESTRING%.*}

		VAR=`nkf -g ${FILENAME}.tex`
		if [ "${VAR}" = "Shift_JIS" ]; then
			platex -kanji=sjis ${FILENAME}.tex
			jbibtex -kanji=sjis ${FILENAME}
			platex -kanji=sjis ${FILENAME}.tex
			platex -kanji=sjis ${FILENAME}.tex
			dvipdfmx ${FILENAME}.dvi
			open ${FILENAME}.pdf
		elif [ "${VAR}" = "EUC-JP" ]; then
			platex -kanji=euc ${FILENAME}.tex
			jbibtex -kanji=euc ${FILENAME}
			platex -kanji=euc ${FILENAME}.tex
			platex -kanji=euc ${FILENAME}.tex
			dvipdfmx ${FILENAME}.dvi
			open ${FILENAME}.pdf
		fi
		echo ${VAR}
	}
_EOT_
source ~/.bash_profile
echo "memo: you may need to change texshop setting default to ptex(ptex2pdf)"
