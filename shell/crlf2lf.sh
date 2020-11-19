#!/bin/sh

###################################################
 # Name: crlf2lf.sh
 # Purpose: Windows eol to Unix/Linux eol
 # Author: Michael Scott (m5cott)
 # Created: 2020-11-19
 # License: MIT License
###################################################

arg1=$1

sed -i 's/\r//g' $arg1