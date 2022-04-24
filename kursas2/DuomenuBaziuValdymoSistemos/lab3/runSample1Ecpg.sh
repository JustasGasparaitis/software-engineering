#!/bin/sh
ecpg Sample1.pgc
gcc -I/usr/include/postgresql -c Sample1.c
gcc -o Sample1 Sample1.o -L/usr/lib -lecpg
./Sample1
