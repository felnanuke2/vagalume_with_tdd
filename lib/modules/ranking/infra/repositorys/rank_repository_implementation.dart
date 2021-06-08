import 'package:dartz/dartz.dart';

import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_album_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_music_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/infra/datasource/rank_datasource.dart';

class RankRepositoryImplementation implements IRankRepository {
  final RankDatasource datasource;

  RankRepositoryImplementation({
    required this.datasource,
  });

  @override
  Future<Either<RankFailure, List<RankAlbumEntity>>> getRankAlbuns(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async {
    var result = await datasource.getAlbunsRank(
        dateTime: dateTime, maxItems: maxItems, vagalumeScope: vagalumeScope);
    if (result != null) return Right(result);
    return Left(GetListFailure('error to get album list'));
  }

  @override
  Future<Either<RankFailure, List<RankArtistEntity>>> getRankArtists(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async {
    var result = await datasource.getArtistsRank(
        dateTime: dateTime, maxItems: maxItems, vagalumeScope: vagalumeScope);
    if (result != null) return Right(result);
    return Left(GetListFailure('error to get artist list'));
  }

  @override
  Future<Either<RankFailure, List<RankMusicEntity>>> getRankMusics(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async {
    var result = await datasource.getMusicsRank(
        dateTime: dateTime, maxItems: maxItems, vagalumeScope: vagalumeScope);
    if (result != null) return Right(result);
    return Left(GetListFailure('error to get  music list'));
  }
}

class GetListFailure extends RankFailure {
  final String message;

  GetListFailure(this.message) : super(message: message);
}
