@echo off
setlocal enabledelayedexpansion
bison -yd  minic.y --verbose
flex minic.l
g++  y.tab.c symboltable.