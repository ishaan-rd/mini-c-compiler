@echo off
setlocal enabledelayedexpansion
bison -yd  minic.y --verbose
flex minic.l
gcc  y.tab.c symboltable.