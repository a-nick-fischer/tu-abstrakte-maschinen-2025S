# Zwischencodes - Intermediate Language (IL)

Compiler und Interpreter laufen durch verschieden Phasen ("passes") (lexing, parsing, scope analysis, ...) - dabei wird üblicherweise der Code in verschiedene Datenstrukturen zum weiteren Verwenden gepackt (e.g. AST - abstract syntax **tree**). Da die semantic des ursprünglichen Codes (ein kontinuierlicher String) nicht verloren geht, kann man die neue Struktur als IL bezeichnen.

Meist bezeichnet man aber erst die letzteren Datenstrukturen als IL: Java Byte-Code, Microsoft IL, etc.
Sprich: Von einer IL spricht man im Regelfall erst, sobald ein AST *linearisiert* wurde.


