import 'package:test/test.dart';
import 'package:game_core/game_core.dart';

class _FakeRepo implements GameRepository {
  final Map<String, GameLevel> _levels;
  final Map<String, int> saved = {};
  _FakeRepo(this._levels);

  @override
  Future<GameLevel?> loadLevel(String id) async => _levels[id];

  @override
  Future<void> saveLevelResult(String id, int score) async {
    saved[id] = score;
  }
}

class _SimpleLevel implements GameLevel {
  @override
  final String id;
  _SimpleLevel(this.id);
  
  @override
  List<String> get boardData => const ['A', 'B', 'C'];

  @override
  int get gridHeight => 3;

  @override
  int get gridWidth => 3;

  @override
  String? get name => null;

  @override
  int get pointsToWin => 100;

  @override
  List<String> get targetWords => const ['CAT'];

  @override
  int get timeLimit => 0;
}

void main() {
  test('SimpleGameCore transitions and stream emits', () async {
    final repo = _FakeRepo({'lvl1': _SimpleLevel('lvl1')});
    final core = SimpleGameCore(repository: repo);

    final states = <GameState>[];
    final sub = core.state.listen(states.add);

    expect(core.currentState, isA<Idle>());

    await core.startLevel('lvl1');
    expect(core.currentState, isA<PlayingLevel>());

    await core.levelWon(score: 42);
    expect(core.currentState, isA<LevelWon>());
    expect(repo.saved['lvl1'], 42);

    await core.goIdle();
    expect(core.currentState, isA<Idle>());

    await core.dispose();
    await sub.cancel();

    // Verify stream sequence contains transitions
    expect(states.map((s) => s.runtimeType).toList(), containsAll([
      PlayingLevel,
      LevelWon,
      Idle,
    ]));
  });

  test('startLevel throws when missing level in repo', () async {
    final repo = _FakeRepo({});
    final core = SimpleGameCore(repository: repo);
    expect(() => core.startLevel('nope'), throwsA(isA<StateError>()));
    await core.dispose();
  });

  test('levelWon throws when not playing', () async {
    final core = SimpleGameCore();
    expect(() => core.levelWon(score: 1), throwsA(isA<StateError>()));
    await core.dispose();
  });

  test('InMemoryRepository integrates with SimpleGameCore', () async {
    final repo = InMemoryRepository();
    repo.addLevel(_SimpleLevel('mylevel'));

    final core = SimpleGameCore(repository: repo);
    await core.startLevel('mylevel');
    await core.levelWon(score: 7);

    expect(repo.getResult('mylevel'), 7);
    await core.dispose();
  });
}
