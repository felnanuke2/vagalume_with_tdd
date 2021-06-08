import 'package:dartz/dartz.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_album_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_music_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';

abstract class IRankRepository {
  Future<Either<RankFailure, List<RankMusicEntity>>> getRankMusics(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime});
  Future<Either<RankFailure, List<RankAlbumEntity>>> getRankAlbuns(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime});
  Future<Either<RankFailure, List<RankArtistEntity>>> getRankArtists(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime});
}

enum VagalumeScope {
  Nacional,
  Internacional,
}
