import 'dart:math';

/// Service for managing word lists and selecting appropriate words for levels.
class WordListService {
  final List<String> _words;
  final Random _random;

  WordListService({
    required List<String> words,
    Random? random,
  })  : _words = words,
        _random = random ?? Random();

  /// Get words for a level with specific constraints.
  List<String> getWordsForLevel({
    required int levelNumber,
    required int count,
    int? minLength,
    int? maxLength,
  }) {
    // As level increases, allow longer words
    final effectiveMinLength = minLength ?? 3;
    final effectiveMaxLength = maxLength ?? _calculateMaxLength(levelNumber);

    final candidates = _words.where((word) {
      final length = word.length;
      return length >= effectiveMinLength && length <= effectiveMaxLength;
    }).toList();

    if (candidates.isEmpty) {
      throw StateError(
        'No words available matching constraints: '
        'min=$effectiveMinLength, max=$effectiveMaxLength',
      );
    }

    // Shuffle and take first n words
    candidates.shuffle(_random);
    return candidates.take(count).toList();
  }

  int _calculateMaxLength(int levelNumber) {
    // Every 5 levels, allow one letter longer words
    // Starting with 4 letters at level 1
    // Level 1-5: 4 letters
    // Level 6-10: 5 letters
    // Level 11-15: 6 letters
    // etc.
    return 3 + ((levelNumber - 1) ~/ 5) + 1;
  }
}