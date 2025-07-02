# Registermaschinen

## Registermaschine overview

Eine Registermaschine ist schnell erklärt. Anstatt einen Stack zu haben, auf dem die Operanden liegen, existiert eine art Map, über die die Werte für einzelne Variablen (Register) gelesen werden. Da wir uns in einer VM befinden und nicht auf echter Hardware, gibt es realistisch keine Limitation bzgl. Register-Anzahl - entsprechend kann hier leicht für jede Variable im Code ein entsprechender Register genommen werden.

Hat man also z. B. im Code `a = b + c` stehen, wäre für eine Stackmaschine dieser Code relevant:

```
iload c
iload b
iadd
istore a
```

Für eine Registermaschine äquivalent aber:

```
iadd a, b, c
```


## Registermaschine vs. Stackmaschine

Die meisten VMs sind als Stackmaschine implementiert - warum?
Als Metriken werden hier die Runtime-Performance und generierte Bytecode-Size hergenommen.

Es werden 3 Steps definiert, die eine VM beim Ausführen jeder Instruktion durchlaufen muss:

1. Dispatch
2. Accessing operands
3. Performing computation

### Dispatch

Hierbei geht es lediglich um das Laden der Instruktionen - schaut man sich die Code-Snippets oben an kann man schnell sehen, dass bei der Stackmaschine `4` Instruktionen geladen werden müssen; bei der Registermaschine aber nur eine. 

Bzgl. laden der Instruktion gibt es natürlich mehrere Möglichkeiten, wie im Kapitel [Threaded Code](./004-threaded-code.md) beschrieben wurde. Je schneller man also das Laden einer Instruktion hier schafft (z. B. `inline-threaded dispatch` viel schneller als ein großes `switch` statement für alle opcodes) desto geringer ist hier der Vorteil von der Registermaschine gegenüber der Stackmaschine.

### Accessing operands

Der klare Nachteil von der Registermaschine ist eben, dass es keinen Stack gibt über den die Werte relativ (zum SP) abgefragt werden können. Entsprechend **muss** bei jeder Instruktion alle relevanten Register explizit angegeben werden. Das führt zu:

- Längeren Instruktionen (höhere code-size)
- Mehr memory fetches (fetchen jedes relevanten Registers pro Instruktion)

Mit anderen Worten enthalten Registermaschinen zwar weniger Instruktionen - aber dafür ist jede Instruktion "teurer" als bei Stackmaschinen.

Diese Nachteile von Registermaschinen sind auch der hauptsächliche Grund, warum Stackmaschinen preferred sind.

### Performing computation

In beiden Fällen ist das Ausführen der tatsächlichen (Hardware-)Instruktion natürlich gleich und auch wenig interessant.
Der Vorteil von Registermaschinen ist hier aber, dass loop invariants und redundant loads hier wegoptimiert werden können (das geht bei Stackmaschinen nicht).


## Stats

Hier wurde Java Bytecode zu Register-Code translated - die translation Time ist hier natürlich excluded.

- 46% weniger VM instructions executed
- 26% increase in bytecode size
- 25% increase in bytecode loads
- 1.48 speedup mit switch dispatch bzw. 1.15 mit inline threaded dispatch
    
    - Wobei hier gemeint ist: Wenn Register- und Stackmaschine beide mit switch-dispatch arbeiten -> dann ist die Registermaschine um 1.48 schneller
    - Entsprechend sieht man: Je besser der dispatch, desto geringer wird der Unterschied zw. Stackmaschine und Registermaschine bzgl. performance!


