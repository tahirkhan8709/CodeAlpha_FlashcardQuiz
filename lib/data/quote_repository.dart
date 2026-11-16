import 'dart:math';

import '../models/quote.dart';

class QuoteRepository {
  QuoteRepository._();

  static final Random _random = Random();
  static int _lastIndex = -1;

  static const List<Quote> quotes = [
    Quote(
      text: 'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
    ),
    Quote(
      text: 'It always seems impossible until it is done.',
      author: 'Nelson Mandela',
    ),
    Quote(
      text: 'Whether you think you can, or you think you can\'t, you\'re right.',
      author: 'Henry Ford',
    ),
    Quote(
      text: 'The best way to predict the future is to create it.',
      author: 'Peter Drucker',
    ),
    Quote(
      text: 'Do what you can, with what you have, where you are.',
      author: 'Theodore Roosevelt',
    ),
    Quote(
      text: 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      author: 'Winston Churchill',
    ),
    Quote(
      text: 'You miss 100% of the shots you don\'t take.',
      author: 'Wayne Gretzky',
    ),
    Quote(
      text: 'The journey of a thousand miles begins with a single step.',
      author: 'Lao Tzu',
    ),
    Quote(
      text: 'Knowing yourself is the beginning of all wisdom.',
      author: 'Aristotle',
    ),
    Quote(
      text: 'Well done is better than well said.',
      author: 'Benjamin Franklin',
    ),
    Quote(
      text: 'Everything you can imagine is real.',
      author: 'Pablo Picasso',
    ),
    Quote(
      text: 'Imagination is more important than knowledge.',
      author: 'Albert Einstein',
    ),
    Quote(
      text: 'The secret of getting ahead is getting started.',
      author: 'Mark Twain',
    ),
    Quote(
      text: 'Fall seven times, stand up eight.',
      author: 'Japanese Proverb',
    ),
    Quote(
      text: 'What you get by achieving your goals is not as important as what you become by achieving your goals.',
      author: 'Zig Ziglar',
    ),
    Quote(
      text: 'Act as if what you do makes a difference. It does.',
      author: 'William James',
    ),
    Quote(
      text: 'Dream big and dare to fail.',
      author: 'Norman Vaughan',
    ),
    Quote(
      text: 'Quality is not an act, it is a habit.',
      author: 'Aristotle',
    ),
    Quote(
      text: 'Small deeds done are better than great deeds planned.',
      author: 'Peter Marshall',
    ),
    Quote(
      text: 'Believe you can and you\'re halfway there.',
      author: 'Theodore Roosevelt',
    ),
    Quote(
      text: 'The harder I work, the luckier I get.',
      author: 'Samuel Goldwyn',
    ),
    Quote(
      text: 'Simplicity is the ultimate sophistication.',
      author: 'Leonardo da Vinci',
    ),
    Quote(
      text: 'Stay hungry, stay foolish.',
      author: 'Stewart Brand',
    ),
    Quote(
      text: 'Turn your wounds into wisdom.',
      author: 'Oprah Winfrey',
    ),
    Quote(
      text: 'Don\'t watch the clock; do what it does. Keep going.',
      author: 'Sam Levenson',
    ),
  ];

  /// Returns a random quote that is never the same as the previous one.
  static Quote random() {
    int index;
    do {
      index = _random.nextInt(quotes.length);
    } while (index == _lastIndex && quotes.length > 1);
    _lastIndex = index;
    return quotes[index];
  }
}