# Нет Mac: как получить IPA для ESign

Если у тебя нет Mac, собирай `ipa` через GitHub Actions (Mac runner в облаке).

## 1) Откуда берется сборка

В проекте есть workflow:

- `.github/workflows/ayugram-ipa.yml`

Он собирает unsigned `Telegram.ipa` и кладет его в Artifacts.

## 2) Как запустить сборку

1. Загрузи этот форк в свой GitHub-репозиторий.
2. Открой вкладку **Actions**.
3. Выбери workflow **AyuGram IPA**.
4. Нажми **Run workflow**.
5. Выбери ветку (обычно `master`) и запусти.

## 3) Как скачать IPA

1. Открой завершенный run.
2. Внизу в **Artifacts** скачай `AyuGram-unsigned-ipa-<build_number>`.
3. В архиве будет `Telegram.ipa`.

## 4) Как поставить через ESign

1. Перенеси `Telegram.ipa` на iPhone (Files/iCloud).
2. В ESign импортируй свой `.p12` и `.mobileprovision`.
3. Открой `Telegram.ipa` -> **Sign** -> **Install**.
4. Если ESign предложит, включи подпись вложенных `PlugIns/Frameworks`.

## 5) Частые проблемы

- Build failed в Actions:
  - проверь, что submodules не отключены;
  - перезапусти workflow (иногда падает из-за внешнего кэша/сети).
- App не запускается после установки:
  - включи `Developer Mode` на iPhone;
  - проверь срок действия сертификата/профиля;
  - профиль должен покрывать bundle id и extensions.
