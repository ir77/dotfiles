// memo: - need command line tools? 
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew doctor
brew install caskroom/cask/brew-cask
brew cask install basictex
brew install nkf ghostscript

sudo tlmgr update --self --all
sudo tlmgr install ptex ptex2pdf jfontmaps jsclasses japanese-otf boxedminipage epsf c

// memo: - change texshop setting default to ptex(ptex2pdf)?
brew cask install texshop

echo "add 'export PATH=/usr/texbin:$PATH' to shell profile"
echo "add following function"
echo "	function tex(){"
echo "		FILESTRING=$1"
echo "		FILENAME=${FILESTRING%.*}"
echo ""
echo "		VAR=`nkf -g ${FILENAME}.tex`"
echo "		if [ "${VAR}" = "Shift_JIS" ]; then"
echo "			platex -kanji=sjis ${FILENAME}.tex"
echo "			jbibtex -kanji=sjis ${FILENAME}"
echo "			platex -kanji=sjis ${FILENAME}.tex"
echo "			platex -kanji=sjis ${FILENAME}.tex"
echo "			dvipdfmx ${FILENAME}.dvi"
echo "			open ${FILENAME}.pdf"
echo "		elif [ "${VAR}" = "EUC-JP" ]; then"
echo "			platex -kanji=euc ${FILENAME}.tex"
echo "			jbibtex -kanji=euc ${FILENAME}"
echo "			platex -kanji=euc ${FILENAME}.tex"
echo "			platex -kanji=euc ${FILENAME}.tex"
echo "			dvipdfmx ${FILENAME}.dvi"
echo "			open ${FILENAME}.pdf"
echo "		fi"
echo "		echo ${VAR}"
echo "	}"
