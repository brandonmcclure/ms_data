#!/usr/bin/bash

# Converts the .puml files into .svg files

cd "${PWD}"/bin/plantuml && for file in *.puml; do basename=$(basename "$file" .puml); cat < "$file" | plantuml -pipe > "$basename.svg"; done && cd ../../..