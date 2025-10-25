import 'dart:convert';
import 'dart:io';

/// Tool to build and filter word lists
void main(List<String> args) async {
  final sources = [
    'assets/word_sources/unix_words.txt',
    'assets/word_sources/scrabble.txt',
    'assets/word_sources/programming.txt',
    // Add more sources as needed
  ];

  final allWords = <String>{};  // Use Set to avoid duplicates

  for (final source in sources) {
    try {
      final file = File(source);
      final lines = await file.readAsLines();
      allWords.addAll(lines.map((word) => word.trim().toUpperCase()));
    } catch (e) {
      print('Warning: Failed to read $source: $e');
    }
  }

  // Filter words based on game constraints
  final filteredWords = WordListFilter.filterWords(
    words: allWords.toList(),
    minLength: 3,  // Minimum word length for easy mode
    maxLength: 8,  // Maximum word length for hard mode
    allowProperNouns: false,
    allowAbbreviations: false,
    allowCompoundWords: true,
  );

  // Sort by length and then alphabetically
  filteredWords.sort((a, b) {
    final lengthCompare = a.length.compareTo(b.length);
    return lengthCompare != 0 ? lengthCompare : a.compareTo(b);
  });

  // Group words by length for easier difficulty management
  final wordsByLength = <int, List<String>>{};
  for (final word in filteredWords) {
    wordsByLength.putIfAbsent(word.length, () => []).add(word);
  }

  // Write filtered words to a JSON file with metadata
  final output = {
    'metadata': {
      'totalWords': filteredWords.length,
      'lengthStats': wordsByLength.map(
        (length, words) => MapEntry(length.toString(), words.length),
      ),
      'generated': DateTime.now().toIso8601String(),
      'sources': sources,
    },
    'wordsByLength': wordsByLength,
  };

  await File('assets/words/word_list.json').writeAsString(
    JsonEncoder.withIndent('  ').convert(output),
  );

  print('Word list generated:');
  print('Total words: ${filteredWords.length}');
  for (final entry in wordsByLength.entries) {
    print('${entry.key} letters: ${entry.value.length} words');
  }
}