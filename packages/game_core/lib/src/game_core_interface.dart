import 'dart:async';
import 'game_state.dart';

/// GameCore is responsible for main app state and broadcasting state changes.
abstract class GameCore {
  /// Broadcast stream of [GameState].
  Stream<GameState> get state;

  /// Current synchronous state if available.
  GameState get currentState;

  /// Start playing a level.
  Future<void> startLevel(String levelId);

  /// Mark current level as won and optionally provide a score.
  Future<void> levelWon({int score});

  /// Go to idle state (e.g., home page).
  Future<void> goIdle();

  /// Dispose resources.
  Future<void> dispose();
}
