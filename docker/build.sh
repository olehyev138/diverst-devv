#!/bin/bash

# Set path from second argument or default to current path
BUILD_PATH=${2:-.}

if [ -n "$1" ]; then
  docker build -t "$1" "$BUILD_PATH" "${@:3}"
else
  echo "ERROR: Requires a docker image tag as first argument (such as diverstdev:X.X)" 1>&2
  exit 1
fi
