# MediHub Flutter

A sample e-commerce app demonstrating analytics and CEP (Customer Engagement Platform) integrations using [Digia Engage](https://digia.tech). Built with Flutter.

## Branches

| Branch | Description |
|--------|-------------|
| `main` | Clean baseline — analytics logs to console only, no SDK dependencies |
| `clevertap` | Digia Engage + CleverTap integration |
| `moengage` | Digia Engage + MoEngage integration |

## This Branch (main)

No Digia or CEP SDK. `AnalyticsService` logs all events via `debugPrint(...)`. Use this as a starting point for your own integration.

## Run

1. Install dependencies: `flutter pub get`
2. Run: `flutter run`

Requires Flutter 3.x+ and Dart 3.x+.
