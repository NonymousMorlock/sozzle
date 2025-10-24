import 'dart:async';

import 'repository.dart';
import 'game_level.dart';

/// A simple in-memory repository useful for testing and quick demos.
class InMemoryRepository implements GameRepository {
  final Map<String, GameLevel> _levels;
  final Map<String, int> _results = {};

  InMemoryRepository([Map<String, GameLevel>? initialLevels]) : _levels = Map.from(initialLevels ?? {});

  @override
  Future<GameLevel?> loadLevel(String id) async => _levels[id];

  @override
  Future<void> saveLevelResult(String id, int score) async {
    _results[id] = score;
  }

  /// Helper to add or replace a level
  void addLevel(GameLevel level) => _levels[level.id] = level;

  /// Get saved result (or null)
  int? getResult(String id) => _results[id];
}

/// A trivial, concrete GameLevel implementation.
class SimpleLevel implements GameLevel {
  @override
  final String id;
  final String? name;
  SimpleLevel(this.id, {this.name});
}
