import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/level/application/word_list_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Stub the root bundle with mock data
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
    'flutter/assets',
    (message) async {
      if (message == null) return null;
      final String key = utf8.decode(message.buffer.asUint8List());
      if (key == 'assets/words/english.txt') {
        final bytes = utf8.encode('ACE\nACT\nADD\nAGE\nAID');
        return Future.value(ByteData.view(Uint8List.fromList(bytes).buffer));
      }
      return null;
    },
  );
  late WordListService service;

  setUp(() {
    service = WordListService();
  });

  test('loadWordList loads and preprocesses words', () async {
    const mockPath = 'assets/words/english.txt';
    final words = await service.loadWordList(mockPath);
    expect(words, isNotEmpty);
    expect(words.first, isA<String>());
    expect(words.first, equals(words.first.toUpperCase()));
  });

  group('getRandomWords', () {
    setUp(() async {
      await service.loadWordList('assets/words/english.txt');
    });

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
  });

  test('getWordByIndex returns correct word', () async {
    await service.loadWordList('assets/words/english.txt');
    final word = service.getWordByIndex(0);
    expect(word, isA<String>());
  });

  test('getAllWords returns unmodifiable list', () async {
    await service.loadWordList('assets/words/english.txt');
    final words = service.getAllWords();
    expect(() => words.add('NEW'), throwsUnsupportedError);
  });

  test('hasWord correctly identifies words', () async {
    await service.loadWordList('assets/words/english.txt');
    final firstWord = service.getWordByIndex(0);
    expect(service.hasWord(firstWord), isTrue);
    expect(service.hasWord('NOTAREALWORD123'), isFalse);
  });

  test('totalWords returns correct count', () async {
    await service.loadWordList('assets/words/english.txt');
    expect(service.totalWords, greaterThan(0));
  });
}