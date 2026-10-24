#!/data/data/com.termux/files/usr/bin/bash

PASS=0
FAIL=0

check_file() {
  local file="$1" expected="$2"
  if [ ! -f "$file" ]; then
    echo "❌ $file — файл не существует"
    FAIL=$((FAIL+1))
    return
  fi
  local lines=$(wc -l < "$file")
  if [ "$lines" -eq 1 ]; then
    echo "❌ $file — слипся в 1 строку (ожидалось ~$expected)"
    FAIL=$((FAIL+1))
    return
  fi
  if [ "$lines" -lt $((expected-5)) ] || [ "$lines" -gt $((expected+15)) ]; then
    echo "⚠️  $file — $lines строк (ожидалось ~$expected)"
    FAIL=$((FAIL+1))
    return
  fi
  echo "✅ $file — $lines строк"
  PASS=$((PASS+1))
}

echo "=== 1. Проверка файлов и числа строк ==="
check_file README.md 160
check_file LICENSE 21
check_file .nojekyll 0
check_file .gitignore 6
check_file install.sh 29
check_file packages/example-pkg/build.sh 8
check_file scripts/check-stars.sh 48
check_file .github/workflows/bot1-star-check.yml 35
check_file .github/workflows/bot2-lint.yml 48
check_file .github/workflows/bot3-build.yml 55

echo ""
echo "=== 2. Проверка синтаксиса shell-скриптов ==="
for f in install.sh scripts/check-stars.sh; do
  if bash -n "$f" 2>/dev/null; then
    echo "✅ $f — синтаксис OK"
    PASS=$((PASS+1))
  else
    echo "❌ $f — синтаксическая ошибка"
    bash -n "$f"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "=== 3. Проверка исполняемых битов ==="
for f in install.sh scripts/check-stars.sh; do
  if [ -x "$f" ]; then
    echo "✅ $f — исполняемый"
    PASS=$((PASS+1))
  else
    echo "❌ $f — не исполняемый (chmod +x $f)"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "=== 4. Проверка старых URL с заглавной буквой ==="
if grep -r 'mixailneAI\.github\.io' . --include='*.md' --include='*.sh' --include='*.yml' 2>/dev/null; then
  echo "❌ Найдены URL с заглавными буквами (должно быть mixailneai.github.io)"
  FAIL=$((FAIL+1))
else
  echo "✅ Старых URL не найдено"
  PASS=$((PASS+1))
fi

echo ""
echo "=== 5. Проверка обязательных TERMUX_PKG_* в example build.sh ==="
for var in TERMUX_PKG_HOMEPAGE TERMUX_PKG_DESCRIPTION TERMUX_PKG_LICENSE TERMUX_PKG_MAINTAINER TERMUX_PKG_VERSION TERMUX_PKG_SRCURL TERMUX_PKG_SHA256; do
  if grep -q "^$var=" packages/example-pkg/build.sh; then
    echo "✅ $var присутствует"
    PASS=$((PASS+1))
  else
    echo "❌ $var отсутствует"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "=== 6. Проверка структуры YAML (баланс скобок) ==="
for f in .github/workflows/*.yml; do
  if grep -q '^name:' "$f" && grep -q '^on:' "$f" && grep -q '^jobs:' "$f"; then
    echo "✅ $f — базовые секции на месте"
    PASS=$((PASS+1))
  else
    echo "❌ $f — не хватает секций name/on/jobs"
    FAIL=$((FAIL+1))
  fi
done

echo ""
echo "=== 7. Итоговая структура ==="
find . -type f -not -path './.git/*' -not -path './repo/*' -not -path './debs/*' -not -name 'verify.sh' | sort

echo ""
echo "================================"
echo "РЕЗУЛЬТАТ: ✅ $PASS пройдено, ❌ $FAIL провалено"
echo "================================"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
