import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_artists.dart';
import 'package:mocktail/mocktail.dart';

import 'get_rank_musics_test.dart';

void main() {
  late GetRankArtists getRankArtist;
  late MockRankRepository repository;
  setUp(() {
    repository = MockRankRepository();
    getRankArtist = GetRankArtists(repository: repository);
  });
  test('should be call getRankArtist from repository', () async {
    var response = Right<RankFailure, List<RankArtistEntity>>(<RankArtistEntity>[]);
    when(() => repository.getRankArtists()).thenAnswer((_) async => response);
    var result = await getRankArtist();
    expect(result, response);
  });
}
