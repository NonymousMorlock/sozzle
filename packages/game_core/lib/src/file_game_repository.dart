import 'dart:convert';
import 'dart:io';

import 'repository.dart';
import 'game_level.dart';

/// A very small file-based repository. Stores data as JSON in the provided file.
///
/// Note: This is a simple adapter for demo purposes. It uses dart:io and will
/// not work on web targets. For production use consider using a proper
/// persistence solution or platform-aware storage.
class FileGameRepository implements GameRepository {
  final File file;
  Map<String, dynamic> _cache = {};

  FileGameRepository(String filePath) : file = File(filePath) {
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync(jsonEncode({}));
    }
    try {
      final content = file.readAsStringSync();
      _cache = jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      _cache = {};
    }
  }

  @override
  Future<GameLevel?> loadLevel(String id) async {
    final levels = _cache['levels'] as Map<String, dynamic>?;
    if (levels == null) return null;
    final entry = levels[id] as Map<String, dynamic>?;
    if (entry == null) return null;
    return SimpleLevel(
      id: entry['id'] as String,
      name: entry['name'] as String?,
      gridWidth: entry['gridWidth'] as int? ?? 3,
      gridHeight: entry['gridHeight'] as int? ?? 3,
      boardData: (entry['boardData'] as List<dynamic>?)?.cast<String>() ?? ['A'],
      targetWords: (entry['targetWords'] as List<dynamic>?)?.cast<String>() ?? [],
      timeLimit: entry['timeLimit'] as int? ?? 0,
      pointsToWin: entry['pointsToWin'] as int? ?? 100,
    );
  }

  @override
  Future<void> saveLevelResult(String id, int score) async {
    final results = _cache['results'] as Map<String, dynamic>? ?? {};
    results[id] = score;
    _cache['results'] = results;
    await file.writeAsString(jsonEncode(_cache));
  }

  /// Helper to add a level definition to the file storage.
  Future<void> addLevel(SimpleLevel level) async {
    final levels = _cache['levels'] as Map<String, dynamic>? ?? {};
    levels[level.id] = {'id': level.id, 'name': level.name};
    _cache['levels'] = levels;
    await file.writeAsString(jsonEncode(_cache));
  }
}
