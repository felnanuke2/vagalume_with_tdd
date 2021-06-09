import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_albuns.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_artists.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_musics.dart';
import 'package:genius_clean_arch/modules/ranking/external/datasource/vagalume_dataSource.dart';
import 'package:genius_clean_arch/modules/ranking/infra/datasource/rank_datasource.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_album_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_music_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/repositorys/rank_repository_implementation.dart';

class RankSingleton {
  RankSingleton._internal({Dio? dio}) {
    this._datasource = VagalumeDataSource(dio: dio ?? Dio());
    this._repository = RankRepositoryImplementation(datasource: _datasource);
    this.getRankAlbuns = GetRankAlbuns(repository: _repository);
    this.getRankArtists = GetRankArtists(repository: _repository);
    this.getRankMusics = GetRankMusics(repository: _repository);
  }

  /// the optional dio is using for yours tests
  static RankSingleton instance({Dio? dio}) => RankSingleton._internal(dio: dio);

//dependencies
  late Dio dio;
  late RankDatasource _datasource;
  late RankRepositoryImplementation _repository;
  late GetRankAlbuns getRankAlbuns;
  late GetRankArtists getRankArtists;
  late GetRankMusics getRankMusics;
}
