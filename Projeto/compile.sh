#!/bin/sh

flex $1
clang-3.8 -o $2 lex.yy.c
