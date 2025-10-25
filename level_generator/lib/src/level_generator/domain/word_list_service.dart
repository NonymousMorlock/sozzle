import 'package:flutter/foundation.dart';

/// Service to manage word lists for puzzle generation
abstract class IWordListService {
  /// Returns a random selection of words from the word list
  /// based on difficulty and count parameters
  List<String> getRandomWords({
    required int count,
    required int minLength,
    required int maxLength,
    int minDifficulty = 0, 
    int maxDifficulty = 5,
  });
  
  /// Returns true if the word is valid for puzzle generation
  @protected
  bool isValidWord(String word);

  /// Returns the total number of words available
  @protected
  int get totalWords;
}