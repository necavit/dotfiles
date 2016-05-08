#!/bin/bash

# Initialize our own variables:
download_dir="$HOME/youtube-music"
batch_file=""

# Usage message + exit
function usage {
echo "Usage: youtube-download BATCH_FILE

YouTube downloader, based on the youtube-dl package. Downloads the videos
from the URLs in the batch file and converts them to high quality mp3 files,
stored in $download_dir, by default."
exit 1
}

# Check for help option (not achievable with 'getopts', because it is a long GNU option)
if [[ "$1" = "--help" || "$1" = "-h" ]]; then
  usage
fi

# Check that the batch file exists
if [[ -f $1 && -n "$1" ]]; then
  batch_file=$1
else
  echo "ERROR: The specified batch file: $1 does not exist or is not a regular file." >&2
  usage
fi

# Nice useful information message
echo "INFO: Music will be downloaded and stored in $download_dir."

# Check that the download directory exists and create it if it does not
mkdir -p "$download_dir"

# Check that 'youtube-dl' is installed
if [ ! command -v youtube-dl >/dev/null 2>&1 ]; then
  echo "ERROR: the necessary package youtube-dl is not installed. Exiting."
  exit 1
fi

# Execute youtube-dl with the required options and arguments
youtube-dl -x --audio-format mp3 --audio-quality 0 \
  --yes-playlist \
  -o "$download_dir/%(title)s.%(ext)s" \
  -a $batch_file
