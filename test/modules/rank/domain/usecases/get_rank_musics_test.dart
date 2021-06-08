import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_music_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_musics.dart';
import 'package:mocktail/mocktail.dart';

class MockRankRepository extends Mock implements IRankRepository {}

void main() {
  late GetRankMusics getRankMusic;
  late IRankRepository repository;
  setUp(() {
    repository = MockRankRepository();
    getRankMusic = GetRankMusics(repository: repository);
  });
  test('should be call getRankMusic from Repository', () async {
    var response = Right<RankFailure, List<RankMusicEntity>>([]);
    when(() => repository.getRankMusics()).thenAnswer((_) async => response);
    final result = await getRankMusic();
    expect(result, response);
  });
}
