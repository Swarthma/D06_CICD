#!/bin/bash

TOKEN="$TELEGRAM_BOT_TOKEN"
CHAT_ID="$TELEGRAM_USER_ID"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

JOB_NAME="$1"
STATUS="$2"

if [ "$STATUS" = "success" ]; then
  EMOJI="✅"
  STATUS_TEXT="УСПЕШНО"
else
  EMOJI="❌"
  STATUS_TEXT="ОШИБКА"
fi

TEXT="
${EMOJI} Стадия: $JOB_NAME
📊 Статус: $STATUS_TEXT

📁 Проект: $CI_PROJECT_NAME
🌿 Ветка: $CI_COMMIT_REF_SLUG
👤 Автор: $GITLAB_USER_NAME
"

ENCODED_TEXT=$(echo "$TEXT" | sed 's/ /+/g' | sed 's/$/%0A/g' | tr -d '\n')
curl -s -X POST "$URL" -d "chat_id=$CHAT_ID" -d "text=$ENCODED_TEXT"
echo "Уведомление: $JOB_NAME - $STATUS"