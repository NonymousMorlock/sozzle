import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/game_play/game_play.dart';
import 'package:sozzle/src/level/domain/level_data.dart';
import 'package:sozzle/src/theme/theme.dart';
import 'package:sozzle/src/user_stats/cubit/user_stats_cubit.dart';
import '../../../../helpers/helpers.dart';

class MockUserStatsCubit extends MockCubit<UserStatsState>
    implements UserStatsCubit {}

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class MockGamePlayBloc extends MockBloc<GamePlayEvent, GamePlayState>
    implements GamePlayBloc {}

void main() {
  final boardData = <String>[
    ...'L W OWL'.split(''),
    ...'O O L O'.split(''),
    ...'WORLD W'.split(''),
    ...'R D    '.split(''),
  ];

  final levelData = LevelData(
    boardData: boardData,
    boardWidth: 7,
    boardHeight: 4,
    levelId: 2,
    words: ['LOWR', 'WORD', 'OLD', 'LOW', 'OWL', 'WORLD'],
  );
  group('GamePlayBoard', () {
    late MockUserStatsCubit userStatsCubit;
    late UserStatsState userStatsState;
    late MockThemeCubit themeCubit;
    late MockGamePlayBloc gamePlayBloc;
    setUp(() {
      userStatsCubit = MockUserStatsCubit();
      userStatsState = UserStatsState.initial();
      themeCubit = MockThemeCubit();
      gamePlayBloc = MockGamePlayBloc();
      whenListen<UserStatsState>(
        userStatsCubit,
        Stream.value(userStatsState),
        initialState: userStatsState,
      );
      whenListen<ThemeState>(
        themeCubit,
        Stream.value(const ThemeStateDark()),
        initialState: const ThemeStateDark(),
      );
      whenListen<GamePlayState>(
        gamePlayBloc,
        Stream.value(const GamePlayState(GamePlayActualState.allHidden)),
        initialState: const GamePlayState(GamePlayActualState.allHidden),
      );
    });

    testWidgets('should have Letterboxes', (WidgetTester tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<UserStatsCubit>(
              create: (context) => userStatsCubit,
            ),
            BlocProvider<ThemeCubit>(
              create: (context) => themeCubit,
            ),
            BlocProvider<GamePlayBloc>(
              create: (context) => gamePlayBloc,
            ),
          ],
          child: GamePlayBoard(levelData),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      final futureFinder = find.byType(LetterBox);
      expect(futureFinder, findsWidgets);
    });
  });
}
