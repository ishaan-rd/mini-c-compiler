#!/bin/bash
bison -yd  minic.y --verbose
flex minic.l
gcc  y.tab.c symboltable.c