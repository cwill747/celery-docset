#!/bin/bash

if [[ -e ./dist/jinja2.docset ]]; then
    mkdir -p "$HOME/Library/Application Support/Dash/DocSets/Jinja2"
    cp -r ./dist/jinja2.docset "$HOME/Library/Application Support/Dash/DocSets/Jinja2"
    open -a Dash "$HOME/Library/Application Support/Dash/DocSets/Jinja2/jinja2.docset"
    echo -e "Jinja2 docset successfully installed!"
else
    echo -e "No docset found..."
    echo -e "Execute ./generate.sh to generate the docset..."
fi

