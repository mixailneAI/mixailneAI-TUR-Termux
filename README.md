# mixailneAI TUR Termux

> Personal APT repository for Termux. Non-official, not affiliated with Termux or TUR.

[![Bot 1 - Star Check](https://github.com/mixailneAI/mixailneAI-TUR-Termux/actions/workflows/bot1-star-check.yml/badge.svg)](https://github.com/mixailneAI/mixailneAI-TUR-Termux/actions/workflows/bot1-star-check.yml)
[![Bot 2 - Lint](https://github.com/mixailneAI/mixailneAI-TUR-Termux/actions/workflows/bot2-lint.yml/badge.svg)](https://github.com/mixailneAI/mixailneAI-TUR-Termux/actions/workflows/bot2-lint.yml)
[![Bot 3 - Build](https://github.com/mixailneAI/mixailneAI-TUR-Termux/actions/workflows/bot3-build.yml/badge.svg)](https://github.com/mixailneAI/mixailneAI-TUR-Termux/actions/workflows/bot3-build.yml)

## Что это

`mixailneAI TUR Termux` — персональный APT-репозиторий для Termux. Здесь публикуются мои собственные пакеты, которые устанавливаются стандартной командой:

~~~bash
pkg install имя-пакета
~~~

Это **не** официальный репозиторий и **не** связан с проектом Termux или TUR (Termux User Repository). Это независимый, персональный проект, который я поддерживаю сам.

## Установка репозитория

Одной командой:

~~~bash
curl -sL https://raw.githubusercontent.com/mixailneAI/mixailneAI-TUR-Termux/main/install.sh | bash
~~~

Или вручную:

~~~bash
echo "deb [trusted=yes] https://mixailneai.github.io/mixailneAI-TUR-Termux/ termux extras" > $PREFIX/etc/apt/sources.list.d/mixailneai-tur.list
pkg update
~~~

После подключения можно ставить пакеты:

~~~bash
pkg install mytool
~~~

## Список пакетов

| Пакет | Версия | Описание |
|-------|--------|----------|
| `mytool` | 1.0.0 | Пример утилиты из этого репозитория |

## Требования к пакетам

Каждый пакет, отправленный в этот репозиторий, проходит три автоматические проверки:

1. **Звёзды на GitHub** — у исходного проекта должно быть не менее **10 звёзд**. Проверяется через GitHub API.
2. **Синтаксис и метаданные** — `build.sh` должен проходить `shellcheck` и содержать все обязательные переменные `TERMUX_PKG_*`.
3. **Сборка** — пакет должен успешно собираться для архитектуры `aarch64`.

Если хотя бы одна проверка не пройдена, Pull Request отклоняется ботом с комментарием и указанием причины.

## Как добавить свой пакет

1. Форкните этот репозиторий.
2. Создайте директорию `packages/имя-пакета/`.
3. Положите туда `build.sh` со следующими переменными:

~~~bash
TERMUX_PKG_HOMEPAGE=https://github.com/author/project
TERMUX_PKG_DESCRIPTION="Краткое описание пакета"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@your_nickname"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=https://github.com/author/project/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=...
TERMUX_PKG_DEPENDS=""
~~~

4. Откройте Pull Request в ветку `main`.

Директория `packages/example-pkg/` — это шаблон. Не изменяйте её в PR, создавайте свою.

## Как работают боты

Три GitHub Actions проверяют каждый Pull Request:

| Бот | Файл | Что проверяет |
|-----|------|---------------|
| **Bot 1 — Star Check** | `.github/workflows/bot1-star-check.yml` | ≥ 10 звёзд у проекта на GitHub |
| **Bot 2 — Lint** | `.github/workflows/bot2-lint.yml` | `shellcheck` + обязательные `TERMUX_PKG_*` |
| **Bot 3 — Build** | `.github/workflows/bot3-build.yml` | Сборка `.deb` для `aarch64` |

Bot 3 запускается вручную (**Actions → Bot 3 - Build → Run workflow**), потому что полная сборка Termux-пакетов занимает много минут CI.

При падении любого бота в PR автоматически появляется комментарий с указанием, что именно не так. Если бот не оставил комментарий — смотрите логи во вкладке **Actions**.

## Структура репозитория

~~~
mixailneAI-TUR-Termux/
├── .github/workflows/          # GitHub Actions (боты)
│   ├── bot1-star-check.yml
│   ├── bot2-lint.yml
│   └── bot3-build.yml
├── packages/                   # Исходники пакетов
│   └── example-pkg/
│       └── build.sh
├── scripts/
│   └── check-stars.sh          # Скрипт проверки звёзд (Bot 1)
├── repo/                       # Сгенерированный APT-репозиторий
│   └── dists/termux/...
├── install.sh                  # Установочный скрипт
├── .nojekyll                   # Отключает Jekyll в GitHub Pages
├── .gitignore
├── LICENSE
└── README.md
~~~

## Обновление репозитория вручную

Если добавляете пакет без CI:

~~~bash
# 1. Соберите .deb (пример для example-pkg)
cd packages/example-pkg
dpkg-deb --build . ../../debs/example-pkg_1.0.0_all.deb

# 2. Перегенерируйте APT-репозиторий
cd ../..
termux-apt-repo debs/ repo/

# 3. Запушьте
git add repo/ debs/
git commit -m "Update repo"
git push origin main
~~~

## Лицензия

MIT License. См. файл [LICENSE](LICENSE).

Пакеты, добавляемые в репозиторий, распространяются под лицензиями их оригинальных проектов. Убедитесь, что вы не нарушаете лицензию оригинального ПО.

## Контакты

- GitHub: [@mixailneAI](https://github.com/mixailneAI)
- Email: michail.pyanzin@yandex.ru
