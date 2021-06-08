import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_album_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_music_model.dart';

abstract class RankDatasource {
  Future<List<RankMusicModel>?> getMusicsRank(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime});

  Future<List<RankAlbumModel>?> getAlbunsRank(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime});

  Future<List<RankArtistModel>?> getArtistsRank(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime});
}
