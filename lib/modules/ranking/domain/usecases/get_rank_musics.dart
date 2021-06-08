import 'package:dartz/dartz.dart';

import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_music_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';

abstract class IGetRankMusic {
  Future<Either<RankFailure, List<RankMusicEntity>>> call();
}

class GetRankMusics implements IGetRankMusic {
  IRankRepository repository;
  GetRankMusics({
    required this.repository,
  });

  @override
  Future<Either<RankFailure, List<RankMusicEntity>>> call(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async {
    return await repository.getRankMusics(
        vagalumeScope: vagalumeScope, maxItems: maxItems, dateTime: dateTime);
  }
}
