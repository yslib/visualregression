#!/bin/sh
#

TMP_IMG="tmp_img_aaa.jpg"
while IFS= read -r line
do
  rm -f "$TMP_IMG"
  git show HEAD:"$line" > "$TMP_IMG"
  dir=$(dirname "$line")
  filename=$(basename "$line")
  mkdir -p "ResultDiff/$dir"
  compare "$TMP_IMG" "$line" png:- | montage -geometry +4+4 "$TMP_IMG" - "$line" png:- > "ResultDiff/$line"
done
