## Prolog
Ein Program ist quasi wie ein Beweis. Eine fundamentale Datenstruktur ist die Liste. Diese wird mit `[]` dargestellt. Auf Listenelemente kann man mit `[Head|Tail]` zugreifen wobei `Head` das erste Element und `Tail` alle weiteren enthält.
#### Variablen
Werden EIMALIG an einen Wert gebunden. Schlägt ein Ast der Beweisführung/Programmausführung fehl, wird ein Backtracking betrieben und die Variablenbindungen zurückgesetzt.
#### Regeln
Regeln (auch Prozeduren genannt) werden so, als Fakten:
```Prolog
head(stat, stat).
```
oder so als Statements
```Prolog
head(stat, stat) :-
	body1(stat, stat),
	body2(stat, stat),
	bodyn(stat, stat).
```
definiert. Dabei müssen, damit im 2. Bsp. `head` bewiesen ist, alle Subgoals des bodies bewiesen werden.
### Ausführung
#### Resulution
Geht von oben nach unten, links nach rechts und versucht die Goals zu beweisen. (Ausführungsreihenfolge)
#### Unification
Bindet die freien Variablen. Generell liefert die Unifikation `true`, wenn für
- Konstanten beide den gleichen Wert besitzen.
- Strukturen beide den gleichen Namen, Arität haben und alle Argumente ebenfalls Unifizieren.
- freie Variablen keine Bedingung gilt. Liefert immer `true` und beide Variablen werden aneinander gebunden.
- eine Variable und eine Konstante/Struktur keine Bedingung gilt. Liefert immer `true` und die Konstante/Struktur wird an die Variable gebunden
Wenn eine Struktur rekursiv ist kann man entweder `false` zurückgeben oder mit diesen "infinite terms" arbeiten.
##### Implementierung
Mithilfe von Pointern recht einfach realisierbar, in dem einfach dieser auf das jeweilige Objekt zeigt.
### Datenrepräsentation
Da Prolog dynamisch Getypt ist, muss für jedes Objekt ein Tupel von `(tag, value)` gespeichert werden. Prolog hat folgende Basistypen:
- atom (Zeichenketten)
- integer
- structure (terme mit namen, arität)
- unbound variable
- reference
Strukturen werden als Liste dargestellt und Funktoren innerhalb dieser mit dem reference typ verknüpft. Eine etwas bessere Darstellung bekommt man mitilfe der "Tagged Pointer Darstellung", wo die Pointer z.B. einer `List` einen Tag ebensolchen Tag haben. Freie Variablen werden als Selbstreferenz dargestellt. 
#### Datenbereiche
##### Environment stack
Die Abarbeitung der Resolution liefert einen Stack. Dieser Rerpäsentiert gleichzeitig den AND-OR-Tree des Beweises. Für jeden Aufrufs einer Regel wird ein neuer Stackframe angelegt.
##### Trail
Speichert die Adressen der Variablen die gebunden wurden. Resetted alle diese Variablen beim Backtracking.
##### Copy Stack (Heap)
Speichert die Strukturen.
#### Stackframes
##### Deterministischer Stackframe
Im Prinzip aufgebaut wie ein normaler Stackframe mit dynamic link (callers frame) und return address (callers goal).
##### Choicepoint
Speichert zusätzlich alternativen (in der Code area). Außerdem speichert er den state des trail und copy stacks um diese resetten zu können. Hat zusätzlich noch einen previous choice point (dynamic link).
### Optimierungen der Abstrakten Maschinen
##### Variablen Klassifikation
Variablen die nur ein mal in einer Regel vorkommen können nur geschrieben werden und somit eliminiert. Temporäre Variablen kommen nur in einem Subgoal vorkommen können in einem Register gehalten werden. Lokale Variablen werden im Stackframe gespeichert.
##### Clause Indexing
Vergleiche erste Variable von Head und Goal ?????? TODO
#### Last Call Optimization
Versucht Speicher zu sparen in dem Stackframes nach Möglichkeit übereinandergelegt werden.
## Warren Abstract Machine (WAM)
Ist aufgebaut wie die Implementierung einer Imperativen Programmiersprache (argument registers, parameter passing, etc). Hat genau so die Datenbereiche wie oben beschrieben. Hat allerdings noch ein paar zusätzliche Hilfsregister
- CP continuation program pointer (fungiert wie eine Rücksprungadresse/Link Register in RISC)
- B (backtrack point) der letze choice point
- TR top of trail
- A top of stack
- E frame pointer (environment pointer)
- H top of heap
- S current structure being unified
#### Instruktionen
Mit `put_value(Vn, Ri)` wird eine Variable in ein Register geschrieben (erstes Auftreten), ist eine Kopieroperation.
Mit `get_variable(Vn, Ri)` wird eine Variable in ein Register geschrieben (weiteres Auftreten), ist die Unifikation
Mit `unify_constant C` wird eine Konstante Unifiziert. (Falls Argumente einer Regel Strukturen sind) Hier wird unterschieden zwischen Read und Write Mode, da einmal mit einer Struktur unifiziert wird und einmal mit einer Freien Variable, was einem Assign gleichkommt.
`call` funktioniert wie `call, ret`
##### Indexing
????
#### Choicepoint
Speichert neben den Pointer Registern auch die Argument Register.
#### Binary Prolog
Hat nur ein Subgoal. Somit gibt es keine lokalen Variablen sondern nur temporäre. Ist eine Vereinfachte WAM.
## Vienna Abstract Machine (VAM)
Versucht das Paramter Passing bottleneck der WAM zu eliminieren. Es gibt:
- VAM_2p für interpreter
- VAM_1p für compiler
- VAM_ai für abstract interpretation (sammelt analyseinformation für VAM_1p)
### VAM_2p
Hat 2 Instruction Pointer. Einer für ein Subgoal, der andere für den Head. Dabei wir immer eine kombinierte instruktion sprich
```c
switch (*goalptr++ + *headptr++)
```
ausgeführt.
Da man nun 2 IP hat hat man entsprechend nun jeweils 2 Pointer in die Code Area und den Envrionment stack, einen für `goal`, den anderen für `head`.
### VAM_1p
Kombiniert die beiden Instruktionen der VAM_2p zur compile Zeit.
### VAM_AI
Sammelt informationen zu Reference Chain Lengths (0, 1, >1) und Alias Information von Variablen.