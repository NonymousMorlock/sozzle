import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:level_data/level_data.dart';
import 'package:level_generator/core/error/failure.dart';
import 'package:level_generator/src/level_generator/application/board_generator.dart';
import 'package:level_generator/src/level_generator/domain/repos/level_generator_repo.dart';
import 'package:level_generator/src/level_generator/domain/word_list_service.dart';

/// Implements [LevelGeneratorRepo] for generating word search puzzles
class LevelGeneratorRepoImpl implements LevelGeneratorRepo {
  LevelGeneratorRepoImpl(this.wordListService, {Random? random})
      : _random = random ?? Random(),
        _boardGenerator = BoardGenerator(random: random);

  final IWordListService wordListService;
  final Random _random;
  final BoardGenerator _boardGenerator;

  @override
  Future<Either<Failure, LevelData>>? generateLevelFromDict(
      Map<String, dynamic>? dict) async {
    if (dict == null) {
      return Left(Failure([{'error': 'Dictionary is required'}]));
    }

    try {
      // Use word list service to get random words if not specified
      if (!dict.containsKey('words') || (dict['words'] as List).isEmpty) {
        final words = wordListService.getRandomWords(
          count: 5,
          minLength: 3,
          maxLength: 6,
        );
        dict['words'] = words;
      }

      final levelData = LevelData(
        levelId: dict['levelId'] as int,
        words: (dict['words'] as List<dynamic>).cast<String>(),
        boardWidth: dict['boardWidth'] as int,
        boardHeight: dict['boardHeight'] as int,
        boardData: (dict['boardData'] as List<dynamic>).cast<String>(),
        rewards: [],
      );
      return Right(levelData);
    } catch (e) {
      return Left(Failure([{'error': e.toString()}]));
    }
  }

  @override
  Future<Either<Failure, LevelData>>? generateLevelFromJsonFile(
      String? jsonPath) async {
    if (jsonPath == null) {
      return Left(Failure([{'error': 'Json path is required'}]));
    }

    try {
      final data =
          jsonDecode(await _jsonLoader(jsonPath)) as Map<String, dynamic>;
      return await generateLevelFromDict(data);
    } catch (e) {
      return Left(Failure([{'error': e.toString()}]));
    }  Future<String> _jsonLoader(String key) async {
    return await rootBundle.loadString(key);
  }
}