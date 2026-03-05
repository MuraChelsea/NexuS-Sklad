# Flutter Tooling

Для `NexusSklad` Flutter должен идти через Docker, а не через локальный SDK на macOS 13.

Рабочая команда:

```bash
docker run --rm \
  -v "$PWD/nexussklad/apps/mobile":/workspace \
  -w /workspace \
  ghcr.io/cirruslabs/flutter:stable \
  flutter pub get
```

Проверки:

```bash
docker run --rm -v "$PWD/nexussklad/apps/mobile":/workspace -w /workspace ghcr.io/cirruslabs/flutter:stable flutter analyze
docker run --rm -v "$PWD/nexussklad/apps/mobile":/workspace -w /workspace ghcr.io/cirruslabs/flutter:stable flutter test
```

Web build:

```bash
docker run --rm -v "$PWD/nexussklad/apps/mobile":/workspace -w /workspace ghcr.io/cirruslabs/flutter:stable flutter build web --dart-define=NEXUSSKLAD_API_BASE_URL=http://localhost:4000
```
