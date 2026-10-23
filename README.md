# mixailneAI TUR Termux

Personal APT repository for Termux. Non-official, not affiliated with Termux or TUR.

## Требования к пакетам

- Не менее 10 звёзд на GitHub у исходного проекта
- Отсутствие синтаксических ошибок (shellcheck)
- Успешная сборка `.deb`

## Установка репозитория

```bash
echo "deb [trusted=yes] https://mixailneAI.github.io/mixailneAI-TUR-Termux/ termux extras" > $PREFIX/etc/apt/sources.list.d/mixailneai-tur.list
pkg update
```

## Как добавить свой пакет

1. Форкните репозиторий
2. Создайте директорию `packages/имя-пакета/`
3. Положите туда `build.sh` с обязательными переменными `TERMUX_PKG_*`
4. Откройте Pull Request — три бота проверят его автоматически
