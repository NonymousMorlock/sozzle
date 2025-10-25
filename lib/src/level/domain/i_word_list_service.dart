import 'package:flutter/foundation.dart';

/// Service to manage word lists for puzzle generation
abstract class IWordListService {
  /// Loads a word list from the given path
  Future<List<String>> loadWordList(String path);
  
  /// Returns a random selection of words from the loaded list
  /// based on difficulty and count parameters
  List<String> getRandomWords({
    required int count,
    required int minLength,
    required int maxLength,
    int minDifficulty = 0,
    int maxDifficulty = 5,
  });
  
  /// Returns a specific word from the list by index, used for testing
  String getWordByIndex(int index);
  
  /// Returns all currently loaded words
  List<String> getAllWords();
  
  /// Returns true if the word is in the current word list
  bool hasWord(String word);

  /// Returns the total number of words in the list
  int get totalWords;
}