import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:genius_clean_arch/constants/api_key.dart';
import 'package:genius_clean_arch/constants/constants.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/infra/datasource/rank_datasource.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_album_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_music_model.dart';

class VagalumeDataSource implements RankDatasource {
  final Dio dio;
  VagalumeDataSource({
    required this.dio,
  });
  @override
  Future<List<RankAlbumModel>?> getAlbunsRank(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async {
    try {
      final url = VAGALUME_BASE_URL +
          '/rank.php?apikey=$VAGALUME_API_KEY/&type=alb&period'
              '=${_getWeekPeriod(dateTime: dateTime)}&scope=${_getScope(vagalumeScope)}&limit=$maxItems';
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return List.from(response.data['alb']['week'][_getScope(vagalumeScope)])
            .map((e) => RankAlbumModel.fromMap(e))
            .toList();
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<RankArtistModel>?> getArtistsRank(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async {
    try {
      final url = VAGALUME_BASE_URL +
          '/rank.php?apikey=$VAGALUME_API_KEY/&type=art&period'
              '=${_getPeriod(dateTime: dateTime)}&scope=${_getScope(vagalumeScope)}&limit=$maxItems';

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return List.from(response.data['art']['day'][_getScope(vagalumeScope)])
            .map((e) => RankArtistModel.fromMap(e))
            .toList();
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<RankMusicModel>?> getMusicsRank(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async {
    try {
      final url = VAGALUME_BASE_URL +
          '/rank.php?apikey=$VAGALUME_API_KEY/&type=mus&period'
              '=${_getPeriod(dateTime: dateTime)}&scope=${_getScope(vagalumeScope)}&limit=$maxItems';

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return List.from(Map.from(response.data)['mus']['day']['all'])
            .map((e) => RankMusicModel.fromMap(e))
            .toList();
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  String _getPeriod({DateTime? dateTime}) {
    if (dateTime == null) {
      return 'day';
    }
    return 'day&periodVal=${formatDate(dateTime, [yyyy, mm, dd])}';
  }

  String _getWeekPeriod({DateTime? dateTime}) {
    if (dateTime == null) return 'week';

    return 'week&periodVal=${formatDate(dateTime, [yyyy, mm, dd])}';
  }

  String _getScope(VagalumeScope scope) {
    if (scope == VagalumeScope.Nacional) return 'nacional';
    return 'internacional';
  }
}
