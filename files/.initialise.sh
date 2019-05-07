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
    
    cat <<EOF >> ~/.gemrc
    :sources:
    - https://rubygems.org/
    - https://${gemfury_token}@gem.fury.io/ccycloud/
EOF

    mkdir ~/.bundle
    cat <<EOF >> ~/.bundle/config
    ---
    BUNDLE_GEM__FURY__IO: "${gemfury_token}"
EOF

    echo "export BUNDLE_GEMFURY_TOKEN=${gemfury_token}" >> /home/developer/.bash_profile
    source /home/developer/.bash_profile
    touch ~/.setup/.gemfury
}

init
gemfury
