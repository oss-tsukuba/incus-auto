#!/bin/bash

FILE="$1"
HOST="$2"

while IFS= read -r line; do
    if ! grep -qF "$line" "$FILE"; then
        echo "$line" >> "$FILE"
    fi
done < <(ssh-keyscan "$HOST" 2> /dev/null)
