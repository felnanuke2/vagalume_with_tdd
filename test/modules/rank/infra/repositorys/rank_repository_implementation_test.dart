import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_album_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_music_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/infra/datasource/rank_datasource.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_album_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_music_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/repositorys/rank_repository_implementation.dart';
import 'package:mocktail/mocktail.dart';

class MockRankDataSource extends Mock implements RankDatasource {}

void main() {
  late RankRepositoryImplementation rankRepositoryImplementation;
  late RankDatasource datasource;
  setUp(() {
    datasource = MockRankDataSource();
    rankRepositoryImplementation = RankRepositoryImplementation(datasource: datasource);
  });
  group('RankRepositoryImplementation group', () {
    test('should be return a list of rankMusicModel', () async {
      var response = <RankMusicModel>[];
      when(() => datasource.getMusicsRank()).thenAnswer((_) async => response);
      var result = await rankRepositoryImplementation.getRankMusics();
      expect(result, Right(response));
    });

    test('should be return RankFailure on get RankMusic is failure', () async {
      when(() => datasource.getMusicsRank()).thenAnswer((_) async => null);
      var result = await rankRepositoryImplementation.getRankMusics();
      expect(result, isA<Left<RankFailure, List<RankMusicEntity>>>());
    });

    test('should be return a list of rankAlbumModel', () async {
      var response = <RankAlbumModel>[];
      when(() => datasource.getAlbunsRank()).thenAnswer((_) async => response);
      var result = await rankRepositoryImplementation.getRankAlbuns();
      expect(result, Right(response));
    });

    test('should be return RankFailure on get RankAlbum is failure', () async {
      when(() => datasource.getAlbunsRank()).thenAnswer((_) async => null);
      var result = await rankRepositoryImplementation.getRankAlbuns();
      expect(result, isA<Left<RankFailure, List<RankAlbumEntity>>>());
    });

    test('should be return a list of rankArtistModel', () async {
      var response = <RankArtistModel>[];
      when(() => datasource.getArtistsRank()).thenAnswer((_) async => response);
      var result = await rankRepositoryImplementation.getRankArtists();
      expect(result, Right(response));
    });

    test('should be return RankFailure on get RankArtist is failure', () async {
      when(() => datasource.getArtistsRank()).thenAnswer((_) async => null);
      var result = await rankRepositoryImplementation.getRankArtists();
      expect(result, isA<Left<RankFailure, List<RankArtistEntity>>>());
    });
  });
}
