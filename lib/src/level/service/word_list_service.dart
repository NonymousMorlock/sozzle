import 'dart:convert';

import 'package:flutter/services.dart';

/// Service for loading and managing word lists
class WordListService {
  /// Load words for a specific difficulty level
  static Future<List<String>> loadWordsForDifficulty({
    required int minLength,
    required int maxLength,
    int maxWords = 1000,  // Limit total words to prevent memory issues
  }) async {
    final jsonString = await rootBundle.loadString('assets/words/word_list.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final wordsByLength = data['wordsByLength'] as Map<String, dynamic>;

    final allWords = <String>[];
    for (var len = minLength; len <= maxLength; len++) {
      final words = (wordsByLength[len.toString()] as List<dynamic>)
          .cast<String>();
      allWords.addAll(words);
    }

    // Shuffle and limit the number of words
    allWords.shuffle();
    return allWords.take(maxWords).toList();
  }

  /// Get statistics about the word list
  static Future<Map<String, dynamic>> getWordListStats() async {
    final jsonString = await rootBundle.loadString('assets/words/word_list.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    return data['metadata'] as Map<String, dynamic>;
  }
}