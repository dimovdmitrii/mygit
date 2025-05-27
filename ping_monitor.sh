#!/bin/bash

read -p "Адрес: " H
F=0; T=100

while :; do
  P=$(ping -n 1 "$H" 2>/dev/null)
  if [[ $? -ne 0 ]]; then
    ((F++)); echo "[Ошибка] $F подряд"
  else
    F=0
    RT=$(echo "$P" | grep "time=" | sed -n 's/.*time=\([0-9]*\)ms.*/\1/p')
    if [[ $RT ]]; then
      (( RT > T )) && echo "[Замедление] ${RT}мс" || echo "[ОК] ${RT}мс"
    else
      echo "[Предупреждение] не извлечено время пинга"
    fi
  fi
  ((F>=3)) && echo "[Внимание] 3 ошибки подряд" && F=0
  sleep 1
done
