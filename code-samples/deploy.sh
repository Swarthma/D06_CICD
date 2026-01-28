#!/bin/bash

set -e  

PROD_SERVER="192.168.101.8"  
PROD_USER="deployer"
SSH_KEY="/home/gitlab-runner/.ssh/id_rsa"

echo "Проверяем наличие исполняемого файла DO..."
if [ ! -f "DO" ]; then
    echo "Ошибка: Файл DO не найден в текущей директории."
    echo "Содержимое текущей директории:"
    ls -la
    exit 1
fi

echo "Копируем исполняемый файл на продакшн сервер..."

scp -i $SSH_KEY -o StrictHostKeyChecking=no DO $PROD_USER@$PROD_SERVER:/tmp/DO

echo "Устанавливаем приложение на продакшн сервере..."

ssh -i $SSH_KEY -o StrictHostKeyChecking=no $PROD_USER@$PROD_SERVER "
    echo 'Перемещаем файл в /usr/local/bin...'
    sudo mv /tmp/DO /usr/local/bin/DO
    echo 'Устанавливаем права выполнения...'
    sudo chmod +x /usr/local/bin/DO
    echo 'Проверяем установку...'
    which DO
    DO 1
    echo 'Деплой завершен успешно!'
    "