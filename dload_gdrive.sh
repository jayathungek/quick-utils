#!/bin/bash

FILEID=""
DEST=""

print_usage(){
	help_text=$"OPTIONS\n-i ID of the Google Drive file to download (required)\n-d download destination (required)\n"
	printf "$help_text"
}

while getopts "hi:d:" flag; do
	case "${flag}" in
		h) print_usage; exit ;;
		i) FILEID="${OPTARG}" ;;
		d) DEST="${OPTARG}" ;;
		:) echo "Missing option argument for -$OPTARG"; exit 1;;
		*) print_usage; exit 1 ;;
	esac
done

if [ -z "$FILEID" ]; then
   echo "Error: missing argument -i"
   print_usage; exit 1; 
fi

if [ -z "$DEST" ]; then
   echo "Error: missing argument -d"
   print_usage; exit 1; 
fi

if [ ! -f "$DEST" ]; then
  echo "Error: -d flag expects a filename, but found directory! Please pass in a filename."
  exit 1
fi

wget --load-cookies /tmp/cookies.txt \
"https://docs.google.com/uc?export=download&confirm=$(wget --quiet
--save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate
'https://docs.google.com/uc?export=download&id=$FILEID' -O- | sed -rn
's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$FILEID" -O $DEST && rm -rf /tmp/cookies.txt
