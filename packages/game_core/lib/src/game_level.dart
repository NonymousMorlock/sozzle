import 'package:meta/meta.dart';

/// Defines a word puzzle game level.
abstract class GameLevel {
  /// Unique identifier for this level
  String get id;

  /// Optional display name
  String? get name;

  /// Grid dimensions (width x height)
  int get gridWidth;
  int get gridHeight;

  /// Letters arranged in a grid (row by row)
  List<String> get boardData;

  /// Target words to find in this level
  List<String> get targetWords;

  /// Time limit in seconds (0 means no limit)
  int get timeLimit;

  /// Points required to win this level
  int get pointsToWin;
}

/// A basic level implementation.
@immutable
class SimpleLevel implements GameLevel {
  const SimpleLevel({
    required this.id,
    this.name,
    required this.gridWidth,
    required this.gridHeight,
    required this.boardData,
    required this.targetWords,
    this.timeLimit = 0,
    required this.pointsToWin,
  });

  @override
  final String id;

  @override
  final String? name;

  @override
  final int gridWidth;

  @override
  final int gridHeight;

  @override
  final List<String> boardData;

  @override
  final List<String> targetWords;

  @override
  final int timeLimit;

  @override
  final int pointsToWin;

  /// Creates an empty level for testing
  factory SimpleLevel.empty() => const SimpleLevel(
        id: '0',
        gridWidth: 3,
        gridHeight: 3,
        boardData: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'],
        targetWords: [],
        pointsToWin: 0,
      );

  /// Creates a copy with some fields replaced.
  SimpleLevel copyWith({
    String? id,
    String? name,
    int? gridWidth,
    int? gridHeight,
    List<String>? boardData,
    List<String>? targetWords,
    int? timeLimit,
    int? pointsToWin,
  }) {
    return SimpleLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      gridWidth: gridWidth ?? this.gridWidth,
      gridHeight: gridHeight ?? this.gridHeight,
      boardData: boardData ?? this.boardData,
      targetWords: targetWords ?? this.targetWords,
      timeLimit: timeLimit ?? this.timeLimit,
      pointsToWin: pointsToWin ?? this.pointsToWin,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SimpleLevel &&
        other.id == id &&
        other.name == name &&
        other.gridWidth == gridWidth &&
        other.gridHeight == gridHeight &&
        other.timeLimit == timeLimit &&
        other.pointsToWin == pointsToWin &&
        _listEquals(other.boardData, boardData) &&
        _listEquals(other.targetWords, targetWords);
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      gridWidth,
      gridHeight,
      Object.hashAll(boardData),
      Object.hashAll(targetWords),
      timeLimit,
      pointsToWin,
    );
  }

  @override
  String toString() {
    return 'SimpleLevel(id: $id, name: $name, grid: ${gridWidth}x$gridHeight, '
        'words: ${targetWords.length})';
  }
}
