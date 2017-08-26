#!/bin/bash

studioCmd="studio.sh"

command -v $studioCmd >/dev/null 2>&1 || { echo >&2 "$studioCmd not found in the PATH"; exit 1; }

$studioCmd &
