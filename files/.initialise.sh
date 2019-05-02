#!/bin/sh

echo "Please enter your gemfury API token"

read gemfury_token

FILE="/home/developer/.gemrc"

/bin/cat <<EOM >$FILE
:sources:
- https://rubygems.org/
- https://${gemfury_token}@gem.fury.io/ccycloud/
EOM
