#!/bin/bash


for i in {1..100}; do
  while true; do
    fname=$RANDOM
    if [[ ! -e "$fname" ]]; then
      touch "$fname"
      break
    fi
  done
done

echo "Готово: создано 100 файлов в $(pwd)"

