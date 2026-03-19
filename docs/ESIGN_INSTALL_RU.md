# AyuGram iOS: IPA + ESign (RU)

## Что важно

- На Windows собрать iPhone `.ipa` нельзя.
- Сборка делается на macOS + Xcode.
- После этого `.ipa` можно подписать и поставить через ESign.

## 1) Сборка IPA на macOS

Клонируй форк на Mac и в корне проекта выполни:

```bash
chmod +x scripts/ayugram/build_ipa_for_esign.sh

AYU_BUNDLE_ID=com.yourname.AyuGram \
AYU_API_ID=123456 \
AYU_API_HASH=your_api_hash \
AYU_TEAM_ID=YOURTEAMID \
AYU_BUILD_NUMBER=100001 \
./scripts/ayugram/build_ipa_for_esign.sh
```

Готовый файл:

```bash
$HOME/ayugram-build-artifacts/Telegram.ipa
```

## 2) Подготовка для ESign

Нужны:

- сертификат `.p12` + пароль;
- provisioning profile `.mobileprovision` (лучше wildcard вида `com.yourname.*`, чтобы покрыть app/extensions).

Скопируй `Telegram.ipa` на iPhone (Files / AirDrop / iCloud Drive).

## 3) Подпись и установка в ESign

1. Открой ESign.
2. Импортируй `.p12` и `.mobileprovision`.
3. Открой `Telegram.ipa` в ESign.
4. Нажми `Sign`.
5. Выбери импортированный сертификат и профиль.
6. Включи подпись всех вложенных компонентов (`PlugIns/Frameworks`) если ESign это предлагает.
7. Нажми `Install`.

## 4) Если не запускается

- Включи `Developer Mode` на iPhone.
- Проверь, что профиль и сертификат валидны и не истекли.
- Проверь, что bundle id покрывается профилем.
- Переподпиши с новым build (увеличь `AYU_BUILD_NUMBER`).
