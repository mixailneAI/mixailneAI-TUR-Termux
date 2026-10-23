#!/usr/bin/env bash
set -e

BASE_SHA="${1}"
HEAD_SHA="${2}"

CHANGED=$(git diff --name-only "$BASE_SHA" "$HEAD_SHA" | grep 'build.sh' || true)

if [ -z "$CHANGED" ]; then
  echo "Нет изменённых build.sh, пропускаем."
  exit 0
fi

FAILED=0

for file in $CHANGED; do
  echo "Проверяем звёзды для: $file"
  URL=$(grep -E 'TERMUX_PKG_(SRCURL|HOMEPAGE)=' "$file" | head -1 | cut -d'=' -f2- | tr -d '"' | tr -d "'")

  if [ -z "$URL" ]; then
    echo "Не найден URL проекта в $file. Пропускаем."
    continue
  fi

  if echo "$URL" | grep -q 'github.com'; then
    REPO_PATH=$(echo "$URL" | sed -E 's#.*github\.com/([^/]+/[^/]+).*#\1#' | sed 's/\.git$//')
    STARS=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
      "https://api.github.com/repos/$REPO_PATH" | jq -r '.stargazers_count // 0')

    echo "Репозиторий: $REPO_PATH, звёзд: $STARS"
    if [ "$STARS" -lt 10 ]; then
      echo "ОШИБКА: у проекта $REPO_PATH менее 10 звёзд ($STARS)."
      FAILED=1
    fi
  else
    echo "Не GitHub URL, проверка звёзд пропущена."
  fi
done

if [ "$FAILED" -ne 0 ]; then
  echo "Проверка звёзд не пройдена."
  exit 1
fi

echo "Все проекты имеют достаточно звёзд."
