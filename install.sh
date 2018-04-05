#!/bin/bash

FILE=packagelist

readarray -t LINES < "$FILE"
for LINE in "${LINES[@]}"; do
trizen -Syu --noconfirm $LINE
done
