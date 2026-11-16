# codealpha_quotegenerator

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# CodeAlpha_QuoteGenerator

A clean, minimal Random Quote Generator built with Flutter for the CodeAlpha App Development Internship (Task 2).

## Features

- Shows a random quote every time the app opens
- "New Quote" button always shows a different quote from the previous one
- Quote text and author name displayed clearly
- Smooth fade/slide animation between quotes
- Copy button to copy the quote to the clipboard
- Minimal Material 3 UI, no extra packages needed

## Project structure

```
lib/
  main.dart                    App entry point and theme
  models/quote.dart            Quote model (text, author)
  data/quote_repository.dart   Quote list and random picker
  screens/quote_screen.dart    Main UI
```

## Run it

```bash
flutter create CodeAlpha_QuoteGenerator
cd CodeAlpha_QuoteGenerator
# replace the generated lib/ folder with the lib/ folder from this repo
flutter pub get
flutter run
```

## Tech

Flutter, Dart, Material 3