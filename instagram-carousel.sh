#!/bin/bash -e

input_file=$1

if [ -z "$input_file" ]; then
  echo >&2 "Usage: $0 <input-file>"
fi

size=$(identify -format "%w,%h" "$input_file")
width=$(echo "$size" | cut -d',' -f1)
height=$(echo "$size" | cut -d',' -f2)

echo "Input width: ${width}px"
echo "Input height: ${height}px"

slides=$(( $width / 1080 ))
echo "Creating $slides slides..."

filename=$(echo "$input_file" | cut -d'.' -f1)
extension=$(echo "$input_file" | cut -d'.' -f2)

convert "$input_file" -crop "${slides}x1-0-0@" +repage +adjoin "${filename}-%d.${extension}"
