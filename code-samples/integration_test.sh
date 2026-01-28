      #!/bin/bash

      echo "Запуск интеграционных тестов..."

      # Функция для проверки вывода и кода возврата
      run_test() {
          local input=$1
          local expected_output=$2
          local expected_exit_code=$3
          local test_name=$4

          echo "Тест: $test_name"
          echo "Входные данные: $input"
          
          # Запускаем приложение и захватываем вывод и код возврата
          if [ -z "$input" ]; then
              # Если input пустой, запускаем без аргументов
              output=$(./DO 2>&1)
              exit_code=$?
          else
              output=$(./DO "$input" 2>&1)
              exit_code=$?
          fi
          
          echo "Ожидаемый вывод: $expected_output"
          echo "Полученный вывод: $output"
          echo "Ожидаемый код возврата: $expected_exit_code"
          echo "Полученный код возврата: $exit_code"
          
          # Проверяем вывод и код возврата
          if [ "$output" = "$expected_output" ] && [ $exit_code -eq $expected_exit_code ]; then
              echo "✅ Тест пройден успешно"
              return 0
          else
              echo "❌ Тест провален"
              return 1
          fi
      }

      failed_tests=0

      echo "=== Тест 1: Правильный ввод (1) ==="
      run_test "1" "Learning to Linux" 0 "Правильный ввод - Linux"
      if [ $? -ne 0 ]; then ((failed_tests++)); fi

      echo "=== Тест 2: Правильный ввод (6) ==="
      run_test "6" "Learning to CI/CD" 0 "Правильный ввод - CI/CD"
      if [ $? -ne 0 ]; then ((failed_tests++)); fi

      echo "=== Тест 3: Неправильное количество аргументов (нет аргументов) ==="
      run_test "" "Bad number of arguments!" 255 "Неправильное количество аргументов"
      if [ $? -ne 0 ]; then ((failed_tests++)); fi

      echo "=== Тест 4: Пустой аргумент ==="
      run_test "empty" "Bad number!" 254 "Пустой аргумент"
      if [ $? -ne 0 ]; then ((failed_tests++)); fi

      echo "=== Тест 5: Неправильный номер (7) ==="
      run_test "7" "Bad number!" 254 "Неправильный номер"
      if [ $? -ne 0 ]; then ((failed_tests++)); fi

      echo "=== Итоги тестирования ==="
      if [ $failed_tests -eq 0 ]; then
          echo "✅ Все интеграционные тесты пройдены успешно!"
          exit 0
      else
          echo "❌ Провалено тестов: $failed_tests"
          exit 1
      fi