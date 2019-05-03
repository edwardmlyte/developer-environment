#!/bin/bash

#function gemfury {
    if [[ -f "/var/gemfury" ]]; then
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

    touch /var/gemfury
#}

#gemfury
