import 'dart:math';

import 'package:test/test.dart';
import 'package:game_core/game_core.dart';
import 'package:game_core/src/level_generator.dart';

void main() {
  group('LevelGenerator', () {
    late LevelGenerator generator;

    setUp(() {
      // Use a fixed seed for reproducible tests
      generator = LevelGenerator(
        wordList: ['CAT', 'DOG', 'BIRD'],
        random: Random(42),
      );
    });

    test('generates level with correct dimensions', () {
      final level = generator.generateLevel(
        id: 'test1',
        width: 3,
        height: 3,
        targetWordCount: 1,
      );

      expect(level.gridWidth, 3);
      expect(level.gridHeight, 3);
      expect(level.boardData.length, 9);
    });

    test('places target words in the grid', () {
      final level = generator.generateLevel(
        id: 'test2',
        width: 4,
        height: 4,
        targetWordCount: 2,
      );

      expect(level.targetWords.length, 2);
      for (final word in level.targetWords) {
        // Verify word appears in the grid (horizontally)
        final letters = word.split('');
        bool found = false;
        for (int row = 0; row < level.gridHeight; row++) {
          final rowStart = row * level.gridWidth;
          final rowLetters = level.boardData
              .sublist(rowStart, rowStart + level.gridWidth)
              .join();
          if (rowLetters.contains(word)) {
            found = true;
            break;
          }
        }
        expect(found, isTrue, reason: 'Word $word not found in grid');
      }
    });

    test('throws when word list is empty', () {
      generator = LevelGenerator(wordList: []);
      expect(
        () => generator.generateLevel(
          id: 'test3',
          width: 3,
          height: 3,
          targetWordCount: 1,
        ),
        throwsStateError,
      );
    });

    test('respects points and time limits', () {
      final level = generator.generateLevel(
        id: 'test4',
        width: 3,
        height: 3,
        targetWordCount: 1,
        timeLimit: 60,
        pointsToWin: 500,
      );

      expect(level.timeLimit, 60);
      expect(level.pointsToWin, 500);
    });
  });
}