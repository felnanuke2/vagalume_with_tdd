import 'package:dartz/dartz.dart';

import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';

abstract class IGetRankArtist {
  Future<Either<RankFailure, List<RankArtistEntity>>> call();
}

class GetRankArtists implements IGetRankArtist {
  IRankRepository repository;

  GetRankArtists({
    required this.repository,
  });

  @override
  Future<Either<RankFailure, List<RankArtistEntity>>> call(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async {
    return await repository.getRankArtists(
        vagalumeScope: vagalumeScope, maxItems: maxItems, dateTime: dateTime);
  }
}
