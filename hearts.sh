#!/bin/zsh
while sleep 0.07; do printf "%-$(( ( RANDOM % $COLUMNS ) - 1))s\e[0;$(( 30 + ($RANDOM % 8) ))m♥\n"; done
