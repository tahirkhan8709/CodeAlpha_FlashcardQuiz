import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/flashcard.dart';

/// Holds all flashcards in memory and saves them on the device
/// (shared_preferences) so they are still there after restarting the app.
class FlashcardStore extends ChangeNotifier {
  static const String _storageKey = 'flashcards_v1';

  final List<Flashcard> _cards = [];

  List<Flashcard> get cards => List.unmodifiable(_cards);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    _cards.clear();
    if (raw == null) {
      // First launch: start with a few sample cards.
      _cards.addAll(_sampleCards);
      await _save();
    } else {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _cards.addAll(
        decoded.map((e) => Flashcard.fromJson(e as Map<String, dynamic>)),
      );
    }
    notifyListeners();
  }

  Future<void> add(String question, String answer) async {
    _cards.add(
      Flashcard(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        question: question.trim(),
        answer: answer.trim(),
      ),
    );
    notifyListeners();
    await _save();
  }

  Future<void> update(String id, String question, String answer) async {
    final index = _cards.indexWhere((c) => c.id == id);
    if (index == -1) return;
    _cards[index] = _cards[index].copyWith(
      question: question.trim(),
      answer: answer.trim(),
    );
    notifyListeners();
    await _save();
  }

  Future<void> delete(String id) async {
    _cards.removeWhere((c) => c.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_cards.map((c) => c.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  static const List<Flashcard> _sampleCards = [
    Flashcard(
      id: 'sample-1',
      question: 'What language is Flutter written in?',
      answer: 'Dart',
    ),
    Flashcard(
      id: 'sample-2',
      question: 'What is a Widget in Flutter?',
      answer: 'The basic building block of a Flutter UI. Everything on screen is a widget.',
    ),
    Flashcard(
      id: 'sample-3',
      question: 'What is the difference between StatelessWidget and StatefulWidget?',
      answer: 'A StatelessWidget never changes after it is built. A StatefulWidget has a State object and can rebuild when its data changes.',
    ),
    Flashcard(
      id: 'sample-4',
      question: 'Which method tells Flutter to rebuild a StatefulWidget?',
      answer: 'setState()',
    ),
    Flashcard(
      id: 'sample-5',
      question: 'What does "hot reload" do?',
      answer: 'It injects updated code into the running app instantly, without losing the current state.',
    ),
  ];
}