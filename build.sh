#!/usr/bin/env bash

# A simple "build" script to combine all markdown files into a single pdf and html file
# PDF: Requires pdflatex
pandoc -i *.md \
    -f gfm \
    --pdf-engine=xelatex \
    -V mainfont="Roboto" \
    -V monofont="Fira Code" \
    -V geometry:a4paper \
    -V geometry:margin=2cm \
	--toc=true \
	--metadata title="Abstrakte Maschinen Ausarbeitung - 2025S" \
	--metadata date="$(date +"%Y-%m-%d %H:%M")" \
	-s \
    -o out/script.pdf 

# HTMl
pandoc -i *.md \
    -f gfm \
    --pdf-engine=xelatex \
    -V mainfont="Roboto" \
    -V monofont="Fira Code" \
    -V geometry:a4paper \
    -V geometry:margin=2cm \
	--toc=true \
	--metadata title="Abstrakte Maschinen Ausarbeitung - 2025S" \
	--metadata date="$(date +"%Y-%m-%d %H:%M")" \
	-s \
    -o out/script.html
