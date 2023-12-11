#!/bin/bash -e

input_file=$1

if [ -z "$input_file" ]; then
  echo >&2 "Usage: $0 <input-file>"
fi

input_dir=$(dirname "$input_file")
size=$(identify -format "%w,%h" "$input_file")
width=$(echo "$size" | cut -d',' -f1)
height=$(echo "$size" | cut -d',' -f2)
filename=$(echo "$input_file" | cut -d'.' -f1)
extension=$(echo "$input_file" | cut -d'.' -f2)

echo "Input width: ${width}px"
echo "Input height: ${height}px"

slides=$(( $width / 1080 ))
echo "Creating $slides slides..."

tmp=$(mktemp -d)
convert "$input_file" -crop "${slides}x1-0-0@" +repage +adjoin "${tmp}/slide-%d.${extension}"

slide_filenames=""
for i in $(seq 0 $(($slides - 1))); do
  slide_filenames="${slide_filenames} ${tmp}/slide-${i}.${extension}"
done
convert $slide_filenames "${filename}.pdf"
