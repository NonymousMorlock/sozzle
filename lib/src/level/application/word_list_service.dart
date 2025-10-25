import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sozzle/src/level/domain/i_word_list_service.dart';

/// Implementation of [IWordListService] that loads and manages word lists
class WordListService implements IWordListService {
  WordListService({Random? random}) : _random = random ?? Random();

  final List<String> _words = [];
  final Random _random;

  @override
  Future<List<String>> loadWordList(String path) async {
    final content = await rootBundle.loadString(path);
    _words.clear();
    _words.addAll(content.split('\n').map((w) => w.trim().toUpperCase()));
    return _words;
  }

  @override
  List<String> getRandomWords({
    required int count,
    required int minLength,
    required int maxLength,
    int minDifficulty = 0,
    int maxDifficulty = 5,
  }) {
    // Filter words by length
    final filtered = _words.where((word) {
      final length = word.length;
      return length >= minLength && length <= maxLength;
    }).toList();

    // Shuffle and take count words
    if (filtered.isEmpty) return [];
    filtered.shuffle(_random);
    return filtered.take(count).toList();
  }

  @override
  String getWordByIndex(int index) {
    if (index < 0 || index >= _words.length) {
      throw RangeError('Index $index out of range');
    }
    return _words[index];
  }

  @override
  List<String> getAllWords() => List.unmodifiable(_words);

  @override
  bool hasWord(String word) => _words.contains(word.toUpperCase());

  @override
  int get totalWords => _words.length;
}