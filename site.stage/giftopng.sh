#!/bin/sh
# typical usage:
#
# find . -name "*.gif" -exec sh giftopng.sh {} \;
#

gif=$1
png=`echo $gif | replace .gif .png`
echo "$gif -> $png"
giftopnm $gif | pnmtopng  -compression 9 > $png
