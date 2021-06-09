import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/controller/rank_controller.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/singletons/rank_singleton.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/usecases/usecases_with_vagalume_datasource_test.dart';

void main() {
  late RankController rankController;
  var dio = MockDio();

  test('(Using Http Connection )Test if getmusicStream return a RankStream Complet with valid List',
      () {
    int maxItems = 20;
    rankController = RankController();
    rankController.rankMusicStream(maxItems: maxItems).listen(expectAsync1((event) {
          if (event is RankStreamComplet) expect(event.rankList.length, maxItems);
        }, count: 2));
    expectLater(rankController.rankMusicStream(),
        emitsInOrder([isA<RankStreamAwait>(), isA<RankStreamComplet>()]));
  });

  test('test if getmusicStream return a error when status code != 200', () {
    rankController = RankController(dio: dio);
    when(() => dio.get(any())).thenAnswer(
        (invocation) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 401));

    expectLater(rankController.rankMusicStream(),
        emitsInOrder([isA<RankStreamAwait>(), isA<RankStreamError>()]));
  });
  test(
      '(Using Http Connection )Test if getAlbunsStream return a RankStream Complet with valid List',
      () {
    int maxItems = 20;
    rankController = RankController();
    rankController.rankAlbunsStream(maxItems: maxItems).listen(expectAsync1((event) {
          if (event is RankStreamComplet) expect(event.rankList.length, maxItems);
        }, count: 2));
    expectLater(rankController.rankAlbunsStream(),
        emitsInOrder([isA<RankStreamAwait>(), isA<RankStreamComplet>()]));
  });

  test('test if getAlbunsStream return a error when status code != 200', () {
    rankController = RankController(dio: dio);
    when(() => dio.get(any())).thenAnswer(
        (invocation) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 401));

    expectLater(rankController.rankAlbunsStream(),
        emitsInOrder([isA<RankStreamAwait>(), isA<RankStreamError>()]));
  });
  test(
      '(Using Http Connection )Test if getArtistStream return a RankStream Complet with valid List',
      () {
    int maxItems = 20;
    rankController = RankController();
    rankController.rankArtistStream(maxItems: maxItems).listen(expectAsync1((event) {
          if (event is RankStreamComplet) expect(event.rankList.length, maxItems);
        }, count: 2));
    expectLater(rankController.rankArtistStream(),
        emitsInOrder([isA<RankStreamAwait>(), isA<RankStreamComplet>()]));
  });

  test('test if getArtistStream return a error when status code != 200', () {
    rankController = RankController(dio: dio);
    when(() => dio.get(any())).thenAnswer(
        (invocation) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 401));

    expectLater(rankController.rankAlbunsStream(),
        emitsInOrder([isA<RankStreamAwait>(), isA<RankStreamError>()]));
  });
}
