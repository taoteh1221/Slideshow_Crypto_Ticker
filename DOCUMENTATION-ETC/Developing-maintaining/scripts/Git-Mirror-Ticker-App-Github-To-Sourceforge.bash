#!/bin/bash

#enter your build directory
cd /home/taoteh1221/Compiling/

#uncomment first run only
#git clone --bare --mirror https://github.com/taoteh1221/Slideshow_Crypto_Ticker.git

#enter your repo directory
cd Slideshow_Crypto_Ticker.git

#uncomment first run only
#git remote add sourceforge ssh://taoteh1221@git.code.sf.net/p/dfd-crypto-ticker/code

#uncomment first run only
#git config remote.sourceforge.mirror true


########################################
#run every time to mirror original repo#
########################################

git fetch --quiet origin
git push --quiet sourceforge

git config alias.update-mirror '!git fetch -q origin && git push -q sourceforge'
git update-mirror

echo 'Sourceforge Mirror updated'