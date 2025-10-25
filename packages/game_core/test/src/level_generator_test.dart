import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

void main() {
  late LevelGenerator generator;
  late List<String> wordList;

  setUp(() {
    wordList = [
      'FLUTTER', 'DART', 'CODE', 'APP', 
      'TEST', 'DEBUG', 'BUILD', 'RUN',
      'GAME', 'PLAY', 'WIN', 'LOSE',
      'EASY', 'HARD', 'FUN', 'GOAL',
    ];
    generator = LevelGenerator(wordList: wordList);
  });

  group('LevelGenerator', () {
    test('generates level with correct dimensions', () {
      final config = DifficultyConfig.easy();
      final level = generator.generateLevel(
        id: '1',
        width: config.baseGridSize,
        height: config.baseGridSize,
        difficulty: config,
      );

      expect(level.gridWidth, equals(config.baseGridSize));
      expect(level.gridHeight, equals(config.baseGridSize));
      expect(level.boardData.length, equals(config.baseGridSize * config.baseGridSize));
    });

    test('places target words in the grid', () {
      final config = DifficultyConfig.easy();
      final level = generator.generateLevel(
        id: '1',
        width: config.baseGridSize,
        height: config.baseGridSize,
        difficulty: config,
      );

      // Ensure all target words are placed
      for (final word in level.targetWords) {
        final letters = word.split('');
        bool foundWord = false;

        // Check horizontally
        for (var y = 0; y < level.gridHeight; y++) {
          final row = level.boardData.sublist(
            y * level.gridWidth,
            (y + 1) * level.gridWidth,
          ).join('');
          if (row.contains(word)) {
            foundWord = true;
            break;
          }
        }

        // Check vertically
        if (!foundWord) {
          for (var x = 0; x < level.gridWidth; x++) {
            final column = List.generate(
              level.gridHeight,
              (y) => level.boardData[y * level.gridWidth + x],
            ).join('');
            if (column.contains(word)) {
              foundWord = true;
              break;
            }
          }
        }

        // Check diagonally (top-left to bottom-right)
        if (!foundWord) {
          for (var startY = 0; startY <= level.gridHeight - letters.length; startY++) {
            for (var startX = 0; startX <= level.gridWidth - letters.length; startX++) {
              final diagonal = List.generate(
                letters.length,
                (i) => level.boardData[(startY + i) * level.gridWidth + (startX + i)],
              ).join('');
              if (diagonal == word) {
                foundWord = true;
                break;
              }
            }
            if (foundWord) break;
          }
        }

        expect(foundWord, isTrue, reason: 'Word "$word" not found in grid');
      }
    });

    test('respects difficulty word count constraints', () {
      final config = DifficultyConfig.easy();
      final level = generator.generateLevel(
        id: '1',
        width: config.baseGridSize,
        height: config.baseGridSize,
        difficulty: config,
      );

      expect(
        level.targetWords.length,
        inInclusiveRange(config.minWordsPerLevel, config.maxWordsPerLevel),
      );
    });

    test('respects difficulty word length constraints', () {
      final config = DifficultyConfig.medium();
      final level = generator.generateLevel(
        id: '1',
        width: config.baseGridSize,
        height: config.baseGridSize,
        difficulty: config,
      );

      for (final word in level.targetWords) {
        expect(
          word.length,
          inInclusiveRange(config.minWordLength, config.maxWordLength),
          reason: 'Word "$word" length outside allowed range',
        );
      }
    });

    test('fills remaining spaces with valid letters', () {
      final config = DifficultyConfig.easy();
      final level = generator.generateLevel(
        id: '1',
        width: config.baseGridSize,
        height: config.baseGridSize,
        difficulty: config,
      );

      // All spaces should be filled with uppercase letters A-Z
      for (final letter in level.boardData) {
        expect(letter, matches(RegExp(r'^[A-Z]$')));
      }
    });

    test('generates different levels with same config', () {
      final config = DifficultyConfig.medium();
      final level1 = generator.generateLevel(
        id: '1',
        width: config.baseGridSize,
        height: config.baseGridSize,
        difficulty: config,
      );

      final level2 = generator.generateLevel(
        id: '2',
        width: config.baseGridSize,
        height: config.baseGridSize,
        difficulty: config,
      );

      // Levels should be different (very low probability of being identical)
      expect(level1.boardData, isNot(equals(level2.boardData)));
      expect(level1.targetWords, isNot(equals(level2.targetWords)));
    });

    test('throws when word list is empty', () {
      final emptyGenerator = LevelGenerator(wordList: []);
      final config = DifficultyConfig.easy();

      expect(
        () => emptyGenerator.generateLevel(
          id: '1',
          width: config.baseGridSize,
          height: config.baseGridSize,
          difficulty: config,
        ),
        throwsStateError,
      );
    });

    test('throws when grid is too small for words', () {
      final config = DifficultyConfig.hard();
      
      expect(
        () => generator.generateLevel(
          id: '1',
          width: 2,  // Too small for most words
          height: 2,
          difficulty: config,
        ),
        throwsStateError,
      );
    });
  });
}