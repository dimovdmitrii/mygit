#!/bin/bash


SRC_DIR="$(pwd)"


TARGET_DIR="/opt/280225-wdm/dimov_dmitri/HW20#2"


for file in "$SRC_DIR"/*; do
  filename=$(basename "$file")


  if [[ "$filename" =~ ^[0-9]+$ ]]; then

    if (( filename % 2 == 0 )); then
      mv "$file" "$TARGET_DIR/"
      echo "Перемещён файл: $filename"
    fi
  fi
done

echo "Готово: чётные файлы перемещены в $TARGET_DIR"

