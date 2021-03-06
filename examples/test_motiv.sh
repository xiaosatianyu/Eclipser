#!/bin/bash

# Grey-box concolic should find a program-crashing test case within few seconds.
gcc motiv.c -o motiv.bin -static -g || exit 1
rm -rf box
mkdir box
cd box
dotnet ../../build/Eclipser.dll fuzz -p ../motiv.bin -t 5 -v 1 -o output \
  --src file --maxfilelen 9 -f input

