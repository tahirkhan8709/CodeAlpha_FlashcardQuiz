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


# CodeAlpha_FlashcardQuiz

A Flashcard Quiz App built with Flutter for the CodeAlpha App Development Internship (Task 1).

## Features

- Each flashcard has a question on the front and the answer on the back
- "Show Answer" / "Hide Answer" button (tapping the card also flips it)
- "Next" and "Previous" buttons with a "Card X of Y" progress bar
- Add, edit and delete flashcards from the Manage screen
- Cards are saved on the device, so they are still there after restarting the app
- Clean Material 3 interface with simple animations
- Starts with a few sample cards on first launch

## Project structure

```
lib/
  main.dart                       App entry point and theme
  models/flashcard.dart           Flashcard model (JSON support)
  data/flashcard_store.dart       State + local storage (shared_preferences)
  screens/study_screen.dart       Study mode (flip, next, previous)
  screens/manage_screen.dart      List, edit and delete cards
  widgets/card_form_dialog.dart   Add / edit dialog with validation
```

## Run it

```bash
flutter create codealpha_flashcardquiz
cd codealpha_flashcardquiz
flutter pub add shared_preferences
flutter run
```

## Tech

Flutter, Dart, Material 3, shared_preferencesch


