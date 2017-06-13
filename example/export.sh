#!/usr/bin/env bash

# Bash script for export the docker environment variables
set -e

eval $(ruby /decrypt-var.sh) # This will export all secret keys 

exec "$@"
