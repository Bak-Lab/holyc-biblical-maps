#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
CACHE=${HBM_SOURCE_CACHE:-"$ROOT/.map-source-cache"}
WORK="$ROOT/build/map-assets"
NATURAL_EARTH_URL=https://naturalearth.s3.amazonaws.com/50m_raster/NE1_50M_SR_W.zip
HURLBUT_URL=https://archive.org/download/bibleatlasmanual00hurl/bibleatlasmanual00hurl.pdf

mkdir -p "$CACHE" "$WORK" "$ROOT/assets"

download()
{
  destination=$1
  url=$2
  expected=$3
  if [ ! -f "$destination" ]; then
    curl -fL --retry 3 -o "$destination" "$url"
  fi
  printf '%s  %s\n' "$expected" "$destination" | sha256sum --check --status
}

download "$CACHE/natural-earth.zip" "$NATURAL_EARTH_URL" \
  9e85417223414bbed425aea5dca0f0b4c5661fc94d4f14494140a21a08dfa450
download "$CACHE/hurlbut-atlas.pdf" "$HURLBUT_URL" \
  4dd6e1177186e45ee4b81fce13cd309dfae1a1dcf7854c46e18b8dc230924afd

if [ ! -f "$CACHE/NE1_50M_SR_W/NE1_50M_SR_W.tif" ]; then
  unzip -oq "$CACHE/natural-earth.zip" -d "$CACHE"
fi

pdftoppm -f 51 -l 51 -r 220 -png -singlefile \
  "$CACHE/hurlbut-atlas.pdf" "$WORK/exodus-source"
pdftoppm -f 79 -l 79 -r 220 -png -singlefile \
  "$CACHE/hurlbut-atlas.pdf" "$WORK/jerusalem-source"
pdftoppm -f 87 -l 87 -r 220 -png -singlefile \
  "$CACHE/hurlbut-atlas.pdf" "$WORK/environs-source"

convert_map()
{
  name=$1
  source=$2
  crop=$3
  magick "$source" -crop "$crop" +repage \
    -filter Lanczos -resize 640x360! \
    -modulate 100,250,100 -contrast-stretch 1%x1% \
    -dither None -remap "$WORK/temple-palette.png" \
    "$ROOT/assets/$name.png"
  magick "$ROOT/assets/$name.png" -depth 8 "ppm:$WORK/$name.ppm"
}

magick -size 16x1 xc:'#000000' \
  -fill '#0000aa' -draw 'point 1,0' \
  -fill '#00aa00' -draw 'point 2,0' \
  -fill '#00aaaa' -draw 'point 3,0' \
  -fill '#aa0000' -draw 'point 4,0' \
  -fill '#aa00aa' -draw 'point 5,0' \
  -fill '#aa5500' -draw 'point 6,0' \
  -fill '#aaaaaa' -draw 'point 7,0' \
  -fill '#555555' -draw 'point 8,0' \
  -fill '#5555ff' -draw 'point 9,0' \
  -fill '#55ff55' -draw 'point 10,0' \
  -fill '#55ffff' -draw 'point 11,0' \
  -fill '#ff5555' -draw 'point 12,0' \
  -fill '#ff55ff' -draw 'point 13,0' \
  -fill '#ffff55' -draw 'point 14,0' \
  -fill '#ffffff' -draw 'point 15,0' \
  "$WORK/temple-palette.png"

convert_map near_east \
  "$CACHE/NE1_50M_SR_W/NE1_50M_SR_W.tif" 1590x900+5850+1440
convert_map mediterranean \
  "$CACHE/NE1_50M_SR_W/NE1_50M_SR_W.tif" 1650x930+5100+1260
convert_map bethlehem "$WORK/environs-source.png" 1400x788+300+1080
convert_map jerusalem "$WORK/jerusalem-source.png" 1500x844+260+470
convert_map valley_elah "$WORK/environs-source.png" 1100x619+40+1550
convert_map exodus_route "$WORK/exodus-source.png" 1800x1013+70+430

cc -std=c17 -O2 -Wall -Wextra -Werror \
  "$ROOT/tools/encode_maps.c" -o "$WORK/encode-maps"
"$WORK/encode-maps" "$ROOT/include/HolyMapsRasterData.HC" \
  near_east="$WORK/near_east.ppm" \
  mediterranean="$WORK/mediterranean.ppm" \
  bethlehem="$WORK/bethlehem.ppm" \
  jerusalem="$WORK/jerusalem.ppm" \
  valley_elah="$WORK/valley_elah.ppm" \
  exodus_route="$WORK/exodus_route.ppm"
