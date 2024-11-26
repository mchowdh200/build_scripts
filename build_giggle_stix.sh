#!/bin/env bash
################################################################################
## Build giggle and stix from source to a specified directory
## and optionally copy over binaries to ~/bin
################################################################################

set -euo pipefail

copy_bins=false
while getopts "p:c" opt; do
  case $opt in
    p)
      prefix=$OPTARG
      ;;
    c)
      copy_bins=true # copy ~/bin if set
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

echo "Building giggle/stix under $prefix"
mkdir -p $prefix

## giggle --------------------------------------------------------------------
git clone https://github.com/ryanlayer/giggle.git $prefix/giggle
cd $prefix/giggle
make
cd .. # ie $prefix

## stix ----------------------------------------------------------------------
wget http://www.sqlite.org/2017/sqlite-amalgamation-3170000.zip
unzip sqlite-amalgamation-3170000.zip
git clone https://github.com/ryanlayer/stix.git
git checkout -b testing
cd stix
make
cd .. # ie $prefix

if [[ $copy_bins ]]; then
  cp -v stix/bin/stix ~/bin
  cp -v giggle/bin/giggle ~/bin
fi
