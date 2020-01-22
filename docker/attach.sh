#!/bin/bash

CONTAINER_NAME=${1:-diverstdev}

docker exec -it "$CONTAINER_NAME" /bin/bash
