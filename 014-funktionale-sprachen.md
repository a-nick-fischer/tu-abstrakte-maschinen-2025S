# Funktionale Sprachen
## Symbolische Darstellung
In funktionalen Sprachen haben Tupel/Listen eine große Bedeutung. Als notation werden entweder Bäume, durch `,` separierte Listen `(A,B,C)` in Lisp-ähnlichen sprachen durch ` ` separierte Listen `((A B C) D (E F G))` oder durch die Dot-Notation die die Liste in Element und Restliste teilt dargestellt `(A.(B.C))`. Die Dot-Notation ist leicht zu implementieren, unterstützt aber pro Knoten immer nur zwei Kinder.
In Implementierungen von Funktionalen sprachen ist sind vor allem zwei bezeichnungen für first/head/left und last/tail/right geläufig. `car` und `cdr`.
Bsp: `car(cdr(cdr(l)))` stellt das 3. Element der Liste `l` dar.
## $\lambda$-Kalkül
Der Lambda-Kalkül ist eines der Einfachsten Programiersprachen. Es besteht nur aus Variablen `a, b, ..., z` und Funktionen der Gestalt $\lambda$`<args>.<body>` wo `<args>` Variablen und `<body>` eine Funktion oder Variablen sind. Als letztes gibt des noch die Anwendung einer Funktion auf eine Funktion oder Variablen: `(<func><args>)`.
Zum Rechnen gibt es 3 Regeln:
1. $\alpha$-Reduktion: $\lambda  u.e\equiv \lambda v.[v/u]e\quad v\notin fv(e)$
2. $\beta$-Reduktion: $(\lambda v.f)e\equiv [e/v] f$
3. $\eta$-Reduktion: $\lambda v.(ev)\equiv e\quad v \notin fv(e)$
#### Normalform
Ein lambda-Ausruck ist in Normalform wenn keine Beta- oder Etareduktion mehr angewandt werden kann.
#### Auswertungsreihenfolge
Es kann bei der Auswertung der Ausdrücke passieren, dass zu bestimmten Zeitpunkten unterschiedliche Reduktionen möglich sind. Dabei ist für das Endergebnis egal welcher Ausdruck zuerst reduziert wird. Allerdings können bestimmte Reduktionsreihenfolgen nie terminieren.
## Interpreter im Lambda-Kalkül
Die Frage die sich logischerweise mit der Möglichkeit einer Programmiersprache stellt ist, ob sie mächtig genug ist sich selbst als berechenbare Funktion zu beschreiben, dh. ob es möglich ist eine Funktion `eval()` zu schreiben die angewendet auf einen beliebigen Ausdruck `E` diesen so weit wie möglich reduziert und das Ergebnis retourniert. Dies ist in der tat möglich, außerdem gilt auch `eval(E) = eval(eval(E))`.
## Die SECD Abstrakte Maschine
### Speicher
Nachdem Funktionale Sprachen stark auf Listen aufbauen macht es Sinn, das der Speicher ebenfalls diese Datenstruktur unterstützt. Dabei wird der Speicher in Zellen unterteilt, die jeweils aus einer fixen Anzahl an Speicher Bits bestehen. Jede Zelle ist außerdem eindeutig addressierbar. Ein Tag beschreibt wie die Zelle zu interpretieren ist, dh. ob die Zelle ein Nonterminal `cons` oder ein Terminal zb `integer` darstellt. Für `cons` Zellen ist somit der Speicherbereich in die Felder `car` und `cdr` aufgeteilt. Ein Pointer mit dem Wert`0 (NIL)` ist ungültig und somit nicht als Adresse nutzbar.
### Register
#### S-Register (Stack Register)
Das S-Register zeigt auf eine Liste im Speicher die wie ein Stack agiert, allerdings als Linked-List implementiert ist. Wird also etwas vom Stack gepoppt und gepushed verbleibt der alte Wert als Garbage im Speicher und muss von einem GC eingesammelt werden sollte er nicht mehr gebraucht werden.
Der Stack wird vor allem für `built-in` Funktionen wie `+ - h x/ car cdr` genutzt.
#### E-Register (Environment Register)
Das E-Regitser zeigt auf eine Liste der Argumente der aktuellen Funktion.
#### C-Register (Control Pointer)
Hat das gleiche verhalten wie ein Program Counter in einem Computer. Zeigt auf die nächste auszuführende Instruktion.
#### D-Register (Dump Register)
Zeigt auf eine Liste namens dump. Der dump hat die Aufgabe den Zustand einer Funktion zu Speichern wenn innerhalb der Funktion noch eine Funktion aufgerufen wird. Das wird erreicht in dem der Inhalt des S, E und C Registers auf diesen dump/stack geschrieben wird und diese nach der Beeindigung der Funktion wieder in die entsprechenden Register gepoppt werden.
### Instruktionen
Instruktionen sind einfache Integer Werte meist ohne Argumente. (Byte Code ähnlich) Sie manipulieren die Register in eine vorgegebene Art und Weise. Dabei gibt es zirka 6 Gruppen an Instruktionen:
1. Werte/Objekte auf den S Stack schreiben
2. Builtin Auswertungen auf dem S Stack durchführen.
3. If-then-else Behandlung
4. Non-Rekursive Funktionsbehandlung/Aufrufe
5. Rekursive Funktionsbehandlung
6. I/O
Die ersten zwei Kategorien funktionieren wie in einem normalen Computer auch.
##### If-then-else
ITE hingegen braucht etwas speziellere Behandlung. Hierfür gibt es zwei Instruktionen `SEL` und `JOIN`.
`SEL` schaut auf den obersten Wert am Stack und schaut ob dieser 0 ist oder nicht (boolean). Anschließend wird entweder der nächste Wert in der Instruktionsliste (C-Register) dorthin geladen oder der Else Block genommen und der Übernächste wert in das C-Register geschrieben. Außerdem wird der `cdr` dieses else Zweigs auf den Stack gepushed um später mithilfe eines `JOIN` wieder in das C-Register gepoppt werden zu können. Beispielsweise wird `if null(x) then 10 else -10` als Codeliste zu `(NULL SEL (LDC 10 JOIN)(LDC -10 JOIN))` übersetzt.
##### Nicht-rekursive Funktionen
Bestehen aus einer Liste von Argumenten, dem `LDF (load function)` befehl, dem Function Body, wobei der letzte Befehl des Body ein `RTN` sein muss und dem `AP (apply)` Befehl. Im allgemeinen wird eine Funktion erst mit einem `AP` ausgewertet. Dafür müssen allerdings zuerst die Argumente dieser Funktion ausgewertet werden.
`AP` pushed cddr(S), E und cdr(C) auf den dump, setzt S auf `NIL`. C wird auf den Anfang des Function-body gesetzt. E wird auf `cons` des zweiten Element des ursprünglichen Stacks und `cdr` des Funktion bodies (eigentlich das Environment welches die Funktion selbst braucht) gesetzt.
Wird nun ein `RTN` aufgerufen werden E und C direkt von dem Stack gepoppt und S wird der Pointer zu `cons` von dem alten S und dem Wert am Stack welcher das Ergebnis der Funktion repräsentiert.
##### Rekursive Funktionen
TODO