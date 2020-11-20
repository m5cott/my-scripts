#!/bin/sh

###################################################
 # Name: isochecker.sh
 # Purpose: Gets the SHASUM256 of an iso
 #          and compares it to a SHASUM256 file
 # Author: Michael Scott (m5cott)
 # Created: 2020-11-20
 # License: MIT License
###################################################

arg1="$1"
arg2="$2"

shasum -a 256 $arg1 | cut -d ' ' -f 1 | diff -s $arg2 -
