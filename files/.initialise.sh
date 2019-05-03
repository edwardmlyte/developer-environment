#!/bin/bash

function init {
    mkdir -p ~/.setup
}

function gemfury {
    if [[ -f "~/.setup/.gemfury" ]]; then
        return 0
    fi
    echo "Please enter your gemfury API token"
    
    read gemfury_token
    
    FILE="/home/developer/.gemrc"
    
    cat <<EOF >> $FILE
    :sources:
    - https://rubygems.org/
    - https://${gemfury_token}@gem.fury.io/ccycloud/
EOF

    touch ~/.setup/.gemfury
}

init
gemfury
