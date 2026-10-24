#!/data/data/com.termux/files/usr/bin/bash
set -e

REPO_URL="https://mixailneai.github.io/mixailneAI-TUR-Termux/"
REPO_NAME="mixailneai-tur"
LIST_FILE="$PREFIX/etc/apt/sources.list.d/${REPO_NAME}.list"

if [ -z "$PREFIX" ] || [ ! -d "$PREFIX" ]; then
    echo "Ошибка: похоже, это не Termux. Установите Termux и запустите скрипт снова."
    exit 1
fi

echo "Подключаем репозиторий mixailneAI TUR Termux..."
echo "URL: $REPO_URL"

if [ -f "$LIST_FILE" ]; then
    echo "Репозиторий уже подключён: $LIST_FILE"
else
    echo "deb [trusted=yes arch=all] ${REPO_URL} termux extras" > "$LIST_FILE"
    echo "Файл репозитория создан: $LIST_FILE"
fi

echo "Обновляем списки пакетов..."
pkg update -y

echo ""
echo "Готово."
echo ""
echo "Установка пакетов:"
echo "  pkg install <имя-пакета>"
echo ""
echo "Пример:"
echo "  pkg install hello-tur"
