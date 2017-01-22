#!/bin/bash

SRC=scugens
SO=$SRC.so
pluginsdir=/usr/local/lib/csound/plugins64-6.0
includedir=/usr/local/include/csound

cmd="gcc -O2 -shared -o $SO -fPIC $SRC.c -DUSE_DOUBLE -I$includedir"
echo $cmd
$cmd

echo "To install, type: cp $SO $pluginsdir"

# To check installation, do csound -z ^&1 | grep <ugen>"
