import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_albuns.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_artists.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_musics.dart';
import 'package:genius_clean_arch/modules/ranking/external/datasource/vagalume_dataSource.dart';
import 'package:genius_clean_arch/modules/ranking/infra/repositorys/rank_repository_implementation.dart';

void main() {
  Dio dio = Dio();
  late VagalumeDataSource dataSource;
  late GetRankMusics getRankMusics;
  late GetRankAlbuns getRankAlbuns;
  late GetRankArtists getRankArtists;
  late RankRepositoryImplementation rankRepositoryImplementation;

  setUp(() {
    dataSource = VagalumeDataSource(dio: dio);
    rankRepositoryImplementation = RankRepositoryImplementation(datasource: dataSource);
    getRankMusics = GetRankMusics(repository: rankRepositoryImplementation);
    getRankAlbuns = GetRankAlbuns(repository: rankRepositoryImplementation);
    getRankArtists = GetRankArtists(repository: rankRepositoryImplementation);
  });
  group('Test ItegrationWith Vagalume', () {
    test('test max item in getRankMusics', () async {
      var result = await getRankMusics(maxItems: 30, dateTime: DateTime(2020, 12, 05));
      expect(result.fold((l) => id(l), (r) => id(r).length), 30);
    });
    test('test max item in getRankAlbuns', () async {
      var result = await getRankAlbuns(maxItems: 30, dateTime: DateTime(2020, 12, 05));
      expect(result.fold((l) => id(l), (r) => id(r).length), 30);
    });
    test('test max item in getRankArtists', () async {
      var result = await getRankArtists(maxItems: 30, dateTime: DateTime(2020, 12, 05));
      expect(result.fold((l) => id(l), (r) => id(r).length), 30);
    });
  });
}
