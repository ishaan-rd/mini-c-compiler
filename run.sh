#!/bin/bash
bison -yd  minic.y --verbose
flex minic.l
g++  y.tab.c symboltable.c