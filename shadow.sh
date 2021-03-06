#!/bin/bash

# ======= CONFIG ============================================
# set this to the location of ImageMagick's convert command
CONVERTER="/usr/local/bin/convert"
# set this to the location where your Image geeklet will look
OUTDIRECTORY="$HOME/tmp"
# ===========================================================

# don't mess with these
workdir=$TMPDIR

# start functions
flipit(){
	infile=$1
	outfile=$2
	# set the width and height variables
	ww=`$CONVERTER $infile -format "%w" info:`
	hh=`$CONVERTER $infile -format "%h" info:`
	hhr=`$CONVERTER xc: -format "%[fx:$hh*40/50]" info:`
	# clone the original image, flip it, composite a gradient and append it below the original
	$CONVERTER $infile \
	\( -size ${ww}x0 xc:none \) \
	\( -clone 0 -flip +repage \) \
	\( -clone 0 -alpha extract -flip +repage \
	-size ${ww}x${hh} gradient: +level 0x50% \
	-compose multiply -composite \) \
	\( -clone 2 -clone 3 -alpha off -compose copy_opacity -composite \) \
	-delete 2,3 -channel rgba -alpha on -background none -append $outfile
}

changefont(){
	outfile=$1
	$CONVERTER -background none -fill white -font Helvetica -pointsize 200 -trim label:@- $workdir/$outfile
}

mkdir $OUTDIRECTORY

# create the pieces of the date (year, month, day) in $TMPDIR
date +'%Y'         | changefont year.png
date +'%A %I:%M%p' | changefont day.png
date +'%B %d'      | changefont month.png


flipit "$workdir/year.png" "$OUTDIRECTORY/year.png"
flipit "$workdir/day.png" "$OUTDIRECTORY/day.png"
flipit "$workdir/month.png" "$OUTDIRECTORY/month.png"




exit 0