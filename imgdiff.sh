#!/bin/sh

new_image=$1
prev_image=$2

# quick reject by check the two image size using exiftool
new_image_size=$(exiftool -ImageSize -b -s3 "${new_image}")
prev_image_size=$(exiftool -ImageSize -b -s3 "${prev_image}")

if [ "$new_image_size" != "$prev_image_size" ]; then
    echo $1
    exit 0
else

# echo "${prev_image}" -- "${new_image}"
output=$(compare "${prev_image}" "${new_image}" NULL)
status=$?
if [ $status -ne 0 ]; then
    echo $1
fi
fi
