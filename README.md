## Mini-C-Compiler

Repo for Mini C Compiler using lex, yaac

### How to run

**If on linux based and are not bothered to run all the commands run run.sh**


* `bison -yd .\minic.y --verbose`

* `flex .\minic.l`

* `gcc .\y.tab.c .\symboltable.c` **On Windows based** <br/> `gcc y.tab.c symboltable.c -ll -ly`  **On linux based**
11

* `.\a.exe .\test-case-1.c` **On Windows based** <br /> `./a.out ./test-case-1.c` **On linux based**
