# Pascal P4

## P4 als intermediate code
Pascal compiler generiert `P4` intermediate code.
Interpreter rennt den dann.

### Vorteile

- lesbarer Zwischencode
- forward references werden im Interpreter in einem pass resolved
- portable

### Nachteile

- langsam af

### Possible improvements

- binary P4 code
- direct threaded code interpreter oder JIT compiler


## P4 VM (Interpreter)

### 5 register

| Name | Wofür |
| - | - |
| PC (program counter) | where we at |
| SP (stack pointer) | so wie immer |
| MP (mark stack pointer) | base von top stack frame -> zeigt base für lokale variablen und bis wohin deallokiert werden kann, wenn procedure beendet |
| EP (extreme stack pointer) | max size von stack frames ist known zu compile time -> dorthin pointed EP -> reduziert comparisons von SP mit NP |
| NP (new pointer) | pointed zu top of *heap* (alle anderen pointer waren für Stack) |

Stack-Frame:

||
| - |
| EP <- local stack <- SP |
| locals |
| parameters |
| return address |
| old EP |
| dynamic link |
| static link |
| function value <- MP |


## P4 Compiler

- single pass compiler
- control: syntactic analysis calls lexical analysis, semantic check and code generation
    - lexical analysis: 
        - determines identifiers, keywords, ...
        - skips comments
        - ...
    - syntax analysis: recursive descent parser
- Compiler is about 4k LOC long
- portable through constant definitions
