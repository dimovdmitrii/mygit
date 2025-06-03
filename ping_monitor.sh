#!/bin/bash

read -p "Адрес: " HOST
FAIL_COUNT=0
SLOW_COUNT=0
THRESHOLD=100  # мс

while true; do
  PING_OUTPUT=$(ping -n 1 "$HOST" 2>/dev/null)

  if [[ $? -ne 0 ]]; then
    ((FAIL_COUNT++))
    echo "[Ошибка] Пинг неудачен ($FAIL_COUNT подряд)"
    SLOW_COUNT=0
  else
    # Извлекаем время пинга из строки вида: time=25ms
    TIME_MS=$(echo "$PING_OUTPUT" | grep -o "time=[0-9]*ms" | sed "s/time=\([0-9]*\)ms/\1/")
    
    if [[ -n "$TIME_MS" ]]; then
      if (( TIME_MS > THRESHOLD )); then
        ((SLOW_COUNT++))
        echo "[Замедление] $TIME_MS мс ($SLOW_COUNT подряд)"
        FAIL_COUNT=0
      else
        echo "[ОК] $TIME_MS мс"
        SLOW_COUNT=0
        FAIL_COUNT=0
      fi
    else
      echo "[Предупреждение] Не удалось извлечь время пинга"
      ((FAIL_COUNT++))
    fi
  fi

  # Проверка условий остановки
  if (( FAIL_COUNT >= 3 )); then
    echo "[ВНИМАНИЕ] Пинг неудачен 3 раза подряд. Завершаем."
    break
  fi

  if (( SLOW_COUNT >= 3 )); then
    echo "[ВНИМАНИЕ] Пинг > $THRESHOLD мс 3 раза подряд. Завершаем."
    break
  fi

  sleep 1
done
