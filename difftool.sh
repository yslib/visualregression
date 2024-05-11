#!/bin/sh

git diff ImageResult | fzf \
		--prompt '(ctrl-a to accept change)> ' \
		--bind 'enter:execute-silent(mkdir /tmp/diffimgtmp; git show HEAD:{} > /tmp/diffimgtmp/tmp.png;compare /tmp/diffimgtmp/tmp.png {} png:- | montage -geometry +4+4 /tmp/diffimgtmp/tmp.png - {} png:- | display -title "res" -;rm -rf /tmp/diffimgtmp/)' \
		--preview 'mkdir /tmp/diffimgtmp;git show HEAD:{} > /tmp/diffimgtmp/tmp.png; (echo "====New===="; exiftool {}; echo "====Old====";  exiftool /tmp/diffimgtmp/tmp.png)| bat; rm -rf /tmp/diffimgtmp/' \
		--bind 'ctrl-a:execute-silent(git add {})' \
