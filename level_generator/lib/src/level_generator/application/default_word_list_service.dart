import 'dart:math';

import 'package:level_generator/src/level_generator/domain/word_list_service.dart';

/// Default implementation of [IWordListService] using a predefined word list
class DefaultWordListService implements IWordListService {
  DefaultWordListService({Random? random}) : _random = random ?? Random();

  final Random _random;
  final List<String> _words = _defaultWords;

  @override
  List<String> getRandomWords({
    required int count,
    required int minLength,
    required int maxLength,
    int minDifficulty = 0,
    int maxDifficulty = 5,
  }) {
    // Filter words by length and difficulty
    final filtered = _words.where((word) {
      final length = word.length;
      if (length < minLength || length > maxLength) return false;

      // Simple difficulty based on word length and common letters
      final difficulty = _calculateDifficulty(word);
      return difficulty >= minDifficulty && difficulty <= maxDifficulty;
    }).toList();

    // Shuffle and take count words
    if (filtered.isEmpty) return [];
    filtered.shuffle(_random);
    return filtered.take(count).toList();
  }

  @override
  bool isValidWord(String word) => _words.contains(word.toUpperCase());

  @override
  int get totalWords => _words.length;

  int _calculateDifficulty(String word) {
    // Simple difficulty calculation:
    // 1. Word length (3-4: easy, 5-6: medium, 7+: hard)
    // 2. Uncommon letters (Q,J,X,Z etc)
    // 3. Repeated letters
    var difficulty = 0;

    // Length-based difficulty
    if (word.length <= 4) difficulty += 1;
    else if (word.length <= 6) difficulty += 2;
    else difficulty += 3;

    // Uncommon letters
    final uncommonLetters = RegExp(r'[QJXZVWY]');
    if (word.contains(uncommonLetters)) difficulty += 1;

    // Repeated letters
    final letterCounts = <String, int>{};
    for (final char in word.split('')) {
      letterCounts[char] = (letterCounts[char] ?? 0) + 1;
    }
    if (letterCounts.values.any((count) => count > 1)) difficulty += 1;

    return difficulty;
  }

  // Default words for testing - in production this would come from a file
  static const _defaultWords = [
    'CAT', 'DOG', 'RAT', 'BAT', 'HAT',
    'HOUSE', 'MOUSE', 'TABLE', 'CHAIR', 'LIGHT',
    'WINDOW', 'GARDEN', 'FLOWER', 'TREE', 'BIRD',
    'QUIET', 'JAZZ', 'QUICK', 'JUMP', 'QUIZ'
  ];
}