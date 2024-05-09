#!/bin/sh

git diff | fzf \
		--prompt '(ctrl-a to accept change)> ' \
		--bind 'enter:execute-silent(mkdir /tmp/diffimgtmp; git show HEAD:{} > /tmp/diffimgtmp/tmp.png;compare /tmp/diffimgtmp/tmp.png {} png:- | montage -geometry +5+4 /tmp/diffimgtmp/tmp.png - {} png:- | display -title "res" -;rm -rf /tmp/diffimgtmp/)' \
		--preview 'exiftool {} | bat' \
		--bind 'ctrl-a:execute-silent(git add {})' \
