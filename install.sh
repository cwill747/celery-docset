#!/bin/bash

if [[ -e ./dist/celery.docset ]]; then
    mkdir -p "$HOME/Library/Application Support/Dash/DocSets/Celery"
    cp -r ./dist/celery.docset "$HOME/Library/Application Support/Dash/DocSets/Celery"
    open -a Dash "$HOME/Library/Application Support/Dash/DocSets/Celery/celery.docset"
    echo -e "Celery docset successfully installed!"
else
    echo -e "No docset found..."
    echo -e "Execute ./generate.sh to generate the docset..."
fi
