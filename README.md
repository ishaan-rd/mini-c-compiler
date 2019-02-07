## Mini-C-Compiler

Repo for Mini C Compiler using lex, yaac

### How to run

    bison -yd .\minic.y --verbose

    flex .\minic.l

    gcc .\y.tab.c .\symboltable.c

    .\a.exe .\test-case-1.c