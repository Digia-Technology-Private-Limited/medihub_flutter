# MediHub Flutter — CleverTap Integration

A sample e-commerce app demonstrating analytics and CEP (Customer Engagement Platform) integrations using [Digia Engage](https://digia.tech). Built with Flutter.

## Branches

| Branch | Description |
|--------|-------------|
| `main` | Clean baseline — analytics logs to console only, no SDK dependencies |
| `clevertap` | Digia Engage + CleverTap integration |
| `moengage` | Digia Engage + MoEngage integration |

## This Branch (clevertap)

Full Digia Engage + CleverTap integration. Events are pushed to CleverTap via `AnalyticsService`. Digia Engage renders in-app and native display campaigns.

## Setup

### 1. Create your credentials file

```bash
cp config/secrets.json.example config/secrets.json
```

Fill in `config/secrets.json`:
- **`DIGIA_PROJECT_ID`**: [app.digia.tech](https://app.digia.tech) → Settings → App Settings
- **`CLEVERTAP_ACCOUNT_ID` / `CLEVERTAP_TOKEN` / `CLEVERTAP_REGION`**: CleverTap Dashboard → Settings → Passcode

> `config/secrets.json` is gitignored. This single file feeds all three layers:
> - **Flutter Dart** via `String.fromEnvironment()`
> - **Android native** via Gradle's `dart-defines` decoding → `manifestPlaceholders`
> - **iOS native** via `$(DART_DEFINES)` in `Info.plist` → parsed in `AppDelegate.swift`

### 2. Install and run

```bash
flutter pub get
flutter run --dart-define-from-file=config/secrets.json
```

## Credentials summary

| File | Gitignored | Used by |
|------|-----------|---------|
| `config/secrets.json` | yes | Flutter Dart + Android native + iOS native |

## Documentation

https://docs.digia.tech/engagement/clevertap-integration

## Other Branches
- `main` — console-only analytics baseline
- `moengage` — MoEngage integration
