import 'package:flutter_test/flutter_test.dart';
import 'package:level_generator/src/level_generator/application/default_word_list_service.dart';

void main() {
  late DefaultWordListService service;

  setUp(() {
    service = DefaultWordListService();
  });

  group('getRandomWords', () {
    test('returns correct number of words', () {
      const count = 5;
      final words = service.getRandomWords(
        count: count,
        minLength: 3,
        maxLength: 6,
      );
      expect(words.length, count);
    });

    test('respects length constraints', () {
      const minLength = 3;
      const maxLength = 5;
      final words = service.getRandomWords(
        count: 10,
        minLength: minLength,
        maxLength: maxLength,
      );
      for (final word in words) {
        expect(word.length, greaterThanOrEqualTo(minLength));
        expect(word.length, lessThanOrEqualTo(maxLength));
      }
    });

    test('respects difficulty constraints', () {
      const minDifficulty = 1;
      const maxDifficulty = 2;
      final words = service.getRandomWords(
        count: 5,
        minLength: 3,
        maxLength: 7,
        minDifficulty: minDifficulty,
        maxDifficulty: maxDifficulty,
      );
      expect(words, isNotEmpty);
    });

    test('returns empty list if no words match criteria', () {
      final words = service.getRandomWords(
        count: 5,
        minLength: 10, // No words this long in test data
        maxLength: 12,
      );
      expect(words, isEmpty);
    });
  });

  test('isValidWord correctly identifies words', () {
    expect(service.isValidWord('CAT'), isTrue);
    expect(service.isValidWord('cat'), isTrue);
    expect(service.isValidWord('NOTAWORD123'), isFalse);
  });

  test('totalWords returns correct count', () {
    expect(service.totalWords, equals(20)); // Number of words in _defaultWords
  });
});