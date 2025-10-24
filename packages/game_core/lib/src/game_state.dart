
import 'package:meta/meta.dart';

@immutable
abstract class GameState {
  const GameState();
}

class Idle extends GameState {
  const Idle();
  @override
  String toString() => 'Idle';
}

class Loading extends GameState {
  final String? message;
  const Loading([this.message]);
  @override
  String toString() => 'Loading(${message ?? ''})';
}

class PlayingLevel extends GameState {
  final String levelId;
  const PlayingLevel(this.levelId);
  @override
  String toString() => 'PlayingLevel($levelId)';
}

class Paused extends GameState {
  final String? reason;
  const Paused([this.reason]);
  @override
  String toString() => 'Paused(${reason ?? ''})';
}

class LevelWon extends GameState {
  final String levelId;
  final int score;
  const LevelWon(this.levelId, {this.score = 0});
  @override
  String toString() => 'LevelWon($levelId, score: $score)';
}

class Failed extends GameState {
  final String message;
  const Failed(this.message);
  @override
  String toString() => 'Failed($message)';
}
