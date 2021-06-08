import 'package:dartz/dartz.dart';

import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_album_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';

abstract class IGetRankAlbuns {
  Future<Either<RankFailure, List<RankAlbumEntity>>> call();
}

class GetRankAlbuns implements IGetRankAlbuns {
  IRankRepository repository;

  GetRankAlbuns({
    required this.repository,
  });

  @override
  Future<Either<RankFailure, List<RankAlbumEntity>>> call(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async {
    return await repository.getRankAlbuns(
        dateTime: dateTime, maxItems: maxItems, vagalumeScope: vagalumeScope);
  }
}
