#!/bin/bash

# CONSTANTS EXTENSION FILES #
PNG_EXTENSION="*.png"
JPG_EXTENSION="*.jpg"

# ARGUMENTS #
DIRECTORY_ROOT="$1"

die () {
    echo >&2 "$@"
    exit 1
}

if [[ "$1" == "help" ]]; then
	die "This script needs one argument: directory where to find all the images that we want to compress."
fi


[ "$#" -eq 1 ] || die "One arguemnt required, $# provided!"


echo "* Compression of PNG images..."
find $DIRECTORY_ROOT -iname $PNG_EXTENSION | while read f ; do
	echo "    ...from $f" ;
	pngquant --ext=.png --force "$f" ; done

echo "**** I've finished!! ****"
