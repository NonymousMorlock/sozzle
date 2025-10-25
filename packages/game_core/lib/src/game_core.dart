/// GameCore is the main interface for a word puzzle game.
/// It handles the game state, level progression, and scoring.
abstract class GameCore {
  /// Get the current level data
  GameLevel? get currentLevel;
  
  /// Get the current game state
  GameState get state;
  
  /// Get the current player stats
  PlayerStats get playerStats;
  
  /// Get a stream of game state changes
  Stream<GameState> get stateStream;

  /// Initialize a new level.
  /// If no level is provided, generates the next level based on progression.
  /// Returns false if level is invalid or generation fails.
  Future<bool> initializeLevel([GameLevel? level]);
  
  /// Load the next level based on current progression.
  /// Returns false if generation fails.
  Future<bool> loadNextLevel();
  
  /// Check if a word is valid and update the game state.
  /// Returns true if the word is valid and not previously found.
  bool submitWord(String word);
  
  /// Get a hint by revealing a random letter on the board.
  /// Returns true if a letter was revealed, false if no more hints available.
  bool revealHint();
  
  /// Pause the game, saving the current state.
  void pauseGame();
  
  /// Resume the game from a paused state.
  void resumeGame();
  
  /// Reset the current level.
  void resetLevel();
  
  /// Save the current game state to persistent storage.
  Future<bool> saveGame();
  
  /// Load a saved game state from persistent storage.
  Future<bool> loadGame();
}

import 'game_level.dart';
import 'player_stats.dart';

/// Current state of the game.
enum GameState {
  /// Game is not yet initialized or between levels
  notReady,
  
  /// Game is ready to play
  ready,
  
  /// Game is in progress
  playing,
  
  /// Game is paused
  paused,
  
  /// Level is complete
  levelComplete,
  
  /// Game over (all levels complete)
  gameOver,
  
  /// Error state
  error
}