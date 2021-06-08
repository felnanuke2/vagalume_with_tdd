import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_album_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_albuns.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_artists.dart';
import 'package:mocktail/mocktail.dart';

import 'get_rank_musics_test.dart';

void main() {
  late GetRankAlbuns getRankAlbuns;
  late MockRankRepository repository;
  setUp(() {
    repository = MockRankRepository();
    getRankAlbuns = GetRankAlbuns(repository: repository);
  });
  test('should be call getRankaAlbum from repository', () async {
    var response = Right<RankFailure, List<RankAlbumEntity>>(<RankAlbumEntity>[]);
    when(() => repository.getRankAlbuns()).thenAnswer((_) async => response);
    var result = await getRankAlbuns();
    expect(result, response);
  });
}
