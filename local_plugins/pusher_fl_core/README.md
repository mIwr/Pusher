# Pusher Flutter Core

Fully cross-platform Pusher Flutter core. Contains:

- Indexed assets
- String localizations (en/ru)
- UI controllers implementation
- UI elements

## General

- Dart SDK >=3.4.0

## Project structure

| Structure element    | Description                                                                                                             |
|----------------------|-------------------------------------------------------------------------------------------------------------------------|
| Package assets       | Located at **[./assets](./assets)**. Contains media files                                                               |
| Assets indexator     | Powered by [FlutterGen](https://pub.dev/packages/flutter_gen). Generates [R class](./lib/src/generated/assets.gen.dart) |
| String localizations | Located at **[./l10n](./lib/src/l10n)**. For now supports english and russian languages                                 |
| UI controllers       | Located at **[./lib/src/controller](./lib/src/controller)**                                                             |
| UI                   | Located at **[./lib/src/ui](./lib/src/ui)**                                                                             |
| Flutter extensions   | Located at **[./lib/src/extension](./lib/src/extension)**                                                               |

**Assets re-index cmd**

```
fluttergen -c pubspec.yaml
```
