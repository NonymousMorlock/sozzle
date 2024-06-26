import 'package:sozzle/src/game_play/domain/entities/booster.dart';

/// Current Users progress data
class UserProgressData {
  UserProgressData({
    required this.currentLevel,
    List<Booster>? boosters,
    this.points = 0,
  }) : boosters = boosters ?? [];

  factory UserProgressData.fromMap(Map<String, dynamic> json) =>
      UserProgressData(
        currentLevel: (json['currentLevel'] as num).toInt(),
        boosters: (json['boosters'] as List?)
            ?.cast<Map<String, dynamic>>()
            .map(
              (booster) => Booster.fromId(
                id: booster['id'] as String,
                boosterCount: (booster['boosterCount'] as num).toInt(),
              ),
            )
            .toList(),
        points: (json['points'] as num?)?.toInt() ?? 0,
      );

  /// max level user reached
  final int currentLevel;

  // TODO(Bug): Find a way to make this a set so more than one of the same
  //  booster can't be added
  final List<Booster> boosters;
  final int points;

  Map<String, dynamic> toMap() => {
        'currentLevel': currentLevel,
        'boosters': boosters
            .map(
              (booster) => {
                'id': booster.id,
                'boosterCount': booster.boosterCount,
              },
            )
            .toList(),
        'points': points,
      };

  UserProgressData copyWith({
    int? currentLevel,
    List<Booster>? boosters,
    int? points,
  }) {
    return UserProgressData(
      currentLevel: currentLevel ?? this.currentLevel,
      boosters: boosters ?? this.boosters,
      points: points ?? this.points,
    );
  }
}
