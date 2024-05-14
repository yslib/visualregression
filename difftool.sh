#!/bin/sh

DIFF_DIR="ImageResult"


TMP_IMG="${PWD}/$(date +%s)-$$.png"
git diff "$DIFF_DIR" | fzf \
		--prompt "(ctrl-a to accept)> " \
		--bind "focus:execute-silent(git show HEAD:{} > "$TMP_IMG")+preview(delta <(exiftool {}) <(exiftool "$TMP_IMG")| bat)" \
		--bind "enter:execute-silent(compare "$TMP_IMG" {} png:- | montage -geometry +4+4 "$TMP_IMG" - {} png:- | display -title "res" -)" \
		--bind "ctrl-a:execute-silent(git add {})+reload(git diff ${DIFF_DIR})" \

rm "$TMP_IMG"
