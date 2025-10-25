import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;

/// State for the word list cubit
class WordListState {
  const WordListState({required this.words});

  final List<String> words;
}

/// Cubit to manage the word list loaded from assets
class WordListCubit extends Cubit<WordListState> {
  WordListCubit() : super(const WordListState(words: [])) {
    loadWords();
  }

  Future<void> loadWords() async {
    try {
      final wordList = await rootBundle.loadString('assets/words/enable3k.txt');
      final words = wordList
          .split('\n')
          .where((w) => w.trim().isNotEmpty)
          .map((w) => w.trim().toUpperCase())
          .toList();
      emit(WordListState(words: words));
    } catch (e) {
      // Emit empty list on error
      emit(const WordListState(words: []));
    }
  }
}