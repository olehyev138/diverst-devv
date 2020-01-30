#!/bin/bash

# Note: You usually want to leave these variables if you're just running the container normally from inside the root of the repo
# Set source path from second argument or default to current path
SOURCE_PATH=${2:-"$(pwd)"}
# Set the target path or default to /webapp
TARGET=${3:-/webapp}

DATABASE_HOST=0.0.0.0

if [ -n "$1" ]; then
  docker run -it --name diverstdev --network host --mount type=bind,source="$SOURCE_PATH",target="$TARGET" -e "DATABASE_HOST=$DATABASE_HOST" "${@:4}" "$1"
else
  echo "ERROR: Requires a docker image tag as first argument (such as diverstdev:X.X)" 1>&2
  exit 1
fi
