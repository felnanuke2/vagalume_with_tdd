import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_artists.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_musics.dart';
import 'package:genius_clean_arch/modules/ranking/external/datasource/vagalume_dataSource.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_album_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_music_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/usecases/usecases_with_vagalume_datasource_test.dart';

void main() {
  Dio dio = MockDio();
  late VagalumeDataSource dataSource;

  setUp(() {
    dataSource = VagalumeDataSource(dio: dio);
  });

  group('vagalume datasource tests', () {
    test('should be return a List of RankMusic', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getMusicData, statusCode: 200));
      final result = await dataSource.getMusicsRank();
      expect(result, isA<List<RankMusicModel>>());
    });

    test('should be return a null on try get List of RankMusic | test Dio', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getMusicData, statusCode: 401));
      final result = await dataSource.getMusicsRank();
      expect(result, null);
    });

    test('should be return a List of RankArtist', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getArtistData, statusCode: 200));
      final result = await dataSource.getArtistsRank();
      expect(result, isA<List<RankArtistModel>>());
    });
    test('should be return a null on try get List of RankArtist', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getArtistData, statusCode: 401));
      final result = await dataSource.getArtistsRank();
      expect(result, null);
    });

    test('should be return a List of RankAlbuns', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getAlbunsData, statusCode: 200));
      final result = await dataSource.getAlbunsRank(vagalumeScope: VagalumeScope.Internacional);
      expect(result, isA<List<RankAlbumModel>>());
    });
    test('should be return a null on try get  List of RankAlbuns', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getAlbunsData, statusCode: 401));
      final result = await dataSource.getAlbunsRank();
      expect(result, null);
    });
  });
}
