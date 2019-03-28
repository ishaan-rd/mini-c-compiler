@echo off
setlocal enabledelayedexpansion
bison -yd  minic.y --verbose
flex minic.l
<<<<<<< HEAD
g++  y.tab.c symboltable.
=======
g++  -std=c++11 y.tab.c symboltable.c icg.cpp
>>>>>>> ee6f2567e3cdba69837a174389f2fb2e84599161
