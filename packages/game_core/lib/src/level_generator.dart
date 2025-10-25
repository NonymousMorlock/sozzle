import 'dart:math' as math;

import 'difficulty_config.dart';
import 'game_level.dart';

/// Service for generating word puzzle game levels.
class LevelGenerator {
  final math.Random _random;
  final List<String> _wordList;

  /// Create a level generator with an optional word list and random seed.
  LevelGenerator({
    List<String>? wordList,
    math.Random? random,
  })  : _wordList = wordList ?? const [],
        _random = random ?? math.Random();

  /// Generate a level with random words from the word list.
  ///
  /// The level will have a grid of the specified size and contain
  /// words based on the difficulty configuration.
  SimpleLevel generateLevel({
    required String id,
    String? name,
    required int width,
    required int height,
    required DifficultyConfig difficulty,
  }) {
    if (_wordList.isEmpty) {
      throw StateError('Word list is empty. Cannot generate level.');
    }

    final board = List.filled(width * height, '');
    final targetWords = <String>[];
    final usedPositions = <int>{};

    // Try to place target words
    for (int i = 0; i < difficulty.targetWordsCount && i < _wordList.length; i++) {
      final word = _selectRandomWord();
      if (word == null) continue;

      final positions = _findValidPositions(
        word,
        width,
        height,
        usedPositions,
      );
      if (positions.isEmpty) continue;

      // Place the word
      final start = positions[_random.nextInt(positions.length)];
      _placeWord(word, start, width, board);
      targetWords.add(word);
      usedPositions.addAll(
        List.generate(word.length, (i) => start + i),
      );
    }

    // Fill remaining spaces with random letters
    for (int i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        board[i] = String.fromCharCode(
          _random.nextInt(26) + 65,
        ); // A-Z
      }
    }

    return SimpleLevel(
      id: id,
      name: name,
      gridWidth: width,
      gridHeight: height,
      boardData: board,
      targetWords: targetWords,
      timeLimit: difficulty.timeLimit,
      pointsToWin: targetWords.length * difficulty.pointsPerWord,
    );
  }

  String? _selectRandomWord() {
    if (_wordList.isEmpty) return null;
    return _wordList[_random.nextInt(_wordList.length)];
  }

  List<int> _findValidPositions(
    String word,
    int width,
    int height,
    Set<int> usedPositions,
  ) {
    final validPositions = <int>[];
    final maxStart = width * height - word.length;

    for (int start = 0; start <= maxStart; start++) {
      // Check if position would cause word to wrap
      final startRow = start ~/ width;
      final endRow = (start + word.length - 1) ~/ width;
      if (startRow != endRow) continue;

      // Check if any position is already used
      bool isValid = true;
      for (int i = 0; i < word.length; i++) {
        if (usedPositions.contains(start + i)) {
          isValid = false;
          break;
        }
      }
      if (isValid) validPositions.add(start);
    }

    return validPositions;
  }

  void _placeWord(String word, int start, int width, List<String> board) {
    for (int i = 0; i < word.length; i++) {
      board[start + i] = word[i];
    }
  }
}