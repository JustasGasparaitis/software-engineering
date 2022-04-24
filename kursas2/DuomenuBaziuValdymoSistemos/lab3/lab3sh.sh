#!/bin/sh
ecpg lab3.pgc
gcc -I/usr/include/postgresql -c lab3.c
gcc -o lab3 lab3.o -L/usr/lib -lecpg
./lab3

