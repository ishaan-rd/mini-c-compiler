@echo off
setlocal enabledelayedexpansion
bison -yd  minic.y
flex minic.l
gcc  y.tab.c symboltable.c