#!/bin/bash
bison -yd  minic.y --verbose
flex minic.l
g++  -std=c++11 y.tab.c symboltable.c icg.cpp