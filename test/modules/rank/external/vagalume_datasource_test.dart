import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_album_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_music_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_albuns.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_artists.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_musics.dart';
import 'package:genius_clean_arch/modules/ranking/external/datasource/vagalume_dataSource.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_album_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_music_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/repositorys/rank_repository_implementation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:date_format/date_format.dart' as dateformat;

class MockDio extends Mock implements Dio {}

void main() {
  Dio dio = MockDio();
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

  group('external GetVagalume Data', () {
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
      final result = await dataSource.getAlbunsRank();
      expect(result, isA<List<RankAlbumModel>>());
    });
    test('should be return a null on try get  List of RankAlbuns', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getAlbunsData, statusCode: 401));
      final result = await dataSource.getAlbunsRank();
      expect(result, null);
    });
  });
  group('usecase tests', () {
    test('should be return a  List of RankMusic', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getMusicData, statusCode: 200));
      final result = await getRankMusics();
      expect(result, isA<Right<RankFailure, List<RankMusicEntity>>>());
    });

    test('should be return a  RankFailure on get RankMusic when status code != 200', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getMusicData, statusCode: 401));
      final result = await getRankMusics();
      expect(result, isA<Left<RankFailure, List<RankMusicEntity>>>());
    });

    test('should be return a  List of RankAlbuns', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getAlbunsData, statusCode: 200));
      final result = await getRankAlbuns(vagalumeScope: VagalumeScope.Internacional);
      expect(result, isA<Right<RankFailure, List<RankAlbumEntity>>>());
    });

    test('should be return a  RankFailure on get RankAlbuns when status code != 200', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getAlbunsData, statusCode: 401));
      final result = await getRankAlbuns();
      expect(result, isA<Left<RankFailure, List<RankAlbumEntity>>>());
    });
    test('should be return a  List of RankArtist', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getArtistData, statusCode: 200));
      final result = await getRankArtists();

      expect(result, isA<Right<RankFailure, List<RankArtistEntity>>>());
    });

    test('should be return a  RankFailure on get RankArtist when status code != 200', () async {
      when(() => dio.get(any())).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: ''), data: getAlbunsData, statusCode: 401));
      final result = await getRankArtists();
      expect(result, isA<Left<RankFailure, List<RankArtistEntity>>>());
    });
  });

  test('test format test', () {
    var date = DateTime(2021, 04, 12);
    expect(
        '20210412', dateformat.formatDate(date, [dateformat.yyyy, dateformat.mm, dateformat.dd]));
  });
}

final getMusicData = {
  "mus": {
    "week": {
      "period": {"year": "2011", "week": "34"},
      "all": [
        {
          "id": "3ade68b8gadffdfa3",
          "name": "High Life",
          "url": "https://www.vagalume.com.br/b-o-b/high-life.html",
          "uniques": "28866",
          "views": "31219",
          "art": {
            "id": "3ade68b7gaeb31ea3",
            "name": "B.o.B.",
            "url": "https://www.vagalume.com.br/b-o-b/",
            "pic_small": "https://www.vagalume.com.br/b-o-b/images/profile.jpg",
            "pic_medium": "https://www.vagalume.com.br/b-o-b/images/b-o-b.jpg"
          }
        },
        {
          "id": "3ade68b8gadffdfa3",
          "name": "High Life",
          "url": "https://www.vagalume.com.br/b-o-b/high-life.html",
          "uniques": "28866",
          "views": "31219",
          "art": {
            "id": "3ade68b7gaeb31ea3",
            "name": "B.o.B.",
            "url": "https://www.vagalume.com.br/b-o-b/",
            "pic_small": "https://www.vagalume.com.br/b-o-b/images/profile.jpg",
            "pic_medium": "https://www.vagalume.com.br/b-o-b/images/b-o-b.jpg"
          }
        },
        {
          "id": "3ade68b8gadffdfa3",
          "name": "High Life",
          "url": "https://www.vagalume.com.br/b-o-b/high-life.html",
          "uniques": "28866",
          "views": "31219",
          "art": {
            "id": "3ade68b7gaeb31ea3",
            "name": "B.o.B.",
            "url": "https://www.vagalume.com.br/b-o-b/",
            "pic_small": "https://www.vagalume.com.br/b-o-b/images/profile.jpg",
            "pic_medium": "https://www.vagalume.com.br/b-o-b/images/b-o-b.jpg"
          }
        },
        {
          "id": "3ade68b8gadffdfa3",
          "name": "High Life",
          "url": "https://www.vagalume.com.br/b-o-b/high-life.html",
          "uniques": "28866",
          "views": "31219",
          "art": {
            "id": "3ade68b7gaeb31ea3",
            "name": "B.o.B.",
            "url": "https://www.vagalume.com.br/b-o-b/",
            "pic_small": "https://www.vagalume.com.br/b-o-b/images/profile.jpg",
            "pic_medium": "https://www.vagalume.com.br/b-o-b/images/b-o-b.jpg"
          }
        },
      ]
    }
  }
};

final getAlbunsData = {
  "alb": {
    "week": {
      "period": {"year": "2021", "week": "23"},
      "internacional": [
        {
          "id": "3ade68b7g6b3ffda3",
          "name": "SOUR",
          "url": "https://www.vagalume.com.br/olivia-rodrigo/discografia/sour.html",
          "cover": "https://www.vagalume.com.br/olivia-rodrigo/discografia/sour-W100.jpg",
          "uniques": "2130",
          "views": "2498",
          "published": "2021",
          "art": {
            "id": "3ade68b7gd98d3ea3",
            "name": "Olivia Rodrigo",
            "url": "https://www.vagalume.com.br/olivia-rodrigo/",
            "pic_small": "https://s2.vagalume.com/olivia-rodrigo/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/olivia-rodrigo/images/olivia-rodrigo.jpg"
          }
        },
        {
          "id": "3ade68b6g25e5fda3",
          "name": "Song Review: a Greatest Hits Collection",
          "url":
              "https://www.vagalume.com.br/stevie-wonder/discografia/song-review-a-greatest-hits-collection.html",
          "cover":
              "https://www.vagalume.com.br/stevie-wonder/discografia/song-review-a-greatest-hits-collection-W100.jpg",
          "uniques": "974",
          "views": "1068",
          "published": "2006",
          "art": {
            "id": "3ade68b6g2809eda3",
            "name": "Stevie Wonder",
            "url": "https://www.vagalume.com.br/stevie-wonder/",
            "pic_small": "https://s2.vagalume.com/stevie-wonder/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/stevie-wonder/images/stevie-wonder.jpg"
          }
        },
        {
          "id": "3ade68b6gc064fda3",
          "name": "The Singles Box Set",
          "url": "https://www.vagalume.com.br/eminem/discografia/the-singles-box-set.html",
          "cover": "https://www.vagalume.com.br/eminem/discografia/the-singles-box-set-W100.jpg",
          "uniques": "638",
          "views": "720",
          "published": "2003",
          "art": {
            "id": "3ade68b5gbfe6eda3",
            "name": "Eminem",
            "url": "https://www.vagalume.com.br/eminem/",
            "pic_small": "https://s2.vagalume.com/eminem/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/eminem/images/eminem.jpg"
          }
        },
        {
          "id": "3ade68b6gd078fda3",
          "name": "21",
          "url": "https://www.vagalume.com.br/adele/discografia/21-11.html",
          "cover": "https://www.vagalume.com.br/adele/discografia/21-11-W100.jpg",
          "uniques": "434",
          "views": "504",
          "published": "2011",
          "art": {
            "id": "3ade68b7g6b960ea3",
            "name": "Adele",
            "url": "https://www.vagalume.com.br/adele/",
            "pic_small": "https://s2.vagalume.com/adele/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/adele/images/adele.jpg"
          }
        },
        {
          "id": "3ade68b6gf9acfda3",
          "name": "÷",
          "url": "https://www.vagalume.com.br/ed-sheeran/discografia/-10.html",
          "cover": "https://www.vagalume.com.br/ed-sheeran/discografia/-10-W100.jpg",
          "uniques": "328",
          "views": "371",
          "published": "2017",
          "art": {
            "id": "3ade68b7g30dd1ea3",
            "name": "Ed Sheeran",
            "url": "https://www.vagalume.com.br/ed-sheeran/",
            "pic_small": "https://s2.vagalume.com/ed-sheeran/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/ed-sheeran/images/ed-sheeran.jpg"
          }
        },
        {
          "id": "3ade68b6gbd38fda3",
          "name": "I Am...Sasha Fierce",
          "url": "https://www.vagalume.com.br/beyonce/discografia/i-am-sasha-fierce.html",
          "cover": "https://www.vagalume.com.br/beyonce/discografia/i-am-sasha-fierce-W100.jpg",
          "uniques": "319",
          "views": "364",
          "published": "2008",
          "art": {
            "id": "3ade68b6gf94aeda3",
            "name": "Beyoncé",
            "url": "https://www.vagalume.com.br/beyonce/",
            "pic_small": "https://s2.vagalume.com/beyonce/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/beyonce/images/beyonce.jpg"
          }
        },
        {
          "id": "3ade68b6gf064fda3",
          "name": "Curtain Call: The Hits [Deluxe Edition]",
          "url":
              "https://www.vagalume.com.br/eminem/discografia/curtain-call-the-hits-deluxe-edition.html",
          "cover":
              "https://www.vagalume.com.br/eminem/discografia/curtain-call-the-hits-deluxe-edition-W100.jpg",
          "uniques": "311",
          "views": "356",
          "published": "2005",
          "art": {
            "id": "3ade68b5gbfe6eda3",
            "name": "Eminem",
            "url": "https://www.vagalume.com.br/eminem/",
            "pic_small": "https://s2.vagalume.com/eminem/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/eminem/images/eminem.jpg"
          }
        },
        {
          "id": "3ade68b7gab2ffda3",
          "name": "Justice",
          "url": "https://www.vagalume.com.br/justin-bieber/discografia/justice-11.html",
          "cover": "https://www.vagalume.com.br/justin-bieber/discografia/justice-11-W100.jpg",
          "uniques": "307",
          "views": "364",
          "published": "2021",
          "art": {
            "id": "3ade68b7g840e0ea3",
            "name": "Justin Bieber",
            "url": "https://www.vagalume.com.br/justin-bieber/",
            "pic_small": "https://s2.vagalume.com/justin-bieber/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/justin-bieber/images/justin-bieber.jpg"
          }
        },
        {
          "id": "3ade68b6gbcaefda3",
          "name": "After Hours",
          "url": "https://www.vagalume.com.br/the-weeknd/discografia/after-hours-10.html",
          "cover": "https://www.vagalume.com.br/the-weeknd/discografia/after-hours-10-W100.jpg",
          "uniques": "306",
          "views": "354",
          "published": "2020",
          "art": {
            "id": "3ade68b7gf30e1ea3",
            "name": "The Weeknd",
            "url": "https://www.vagalume.com.br/the-weeknd/",
            "pic_small": "https://s2.vagalume.com/the-weeknd/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/the-weeknd/images/the-weeknd.jpg"
          }
        },
        {
          "id": "3ade68b6gefaefda3",
          "name": "Future Nostalgia",
          "url": "https://www.vagalume.com.br/dua-lipa/discografia/future-nostalgia.html",
          "cover": "https://www.vagalume.com.br/dua-lipa/discografia/future-nostalgia-W100.jpg",
          "uniques": "256",
          "views": "284",
          "published": "2020",
          "art": {
            "id": "3ade68b7ga71d2ea3",
            "name": "Dua Lipa",
            "url": "https://www.vagalume.com.br/dua-lipa/",
            "pic_small": "https://s2.vagalume.com/dua-lipa/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/dua-lipa/images/dua-lipa.jpg"
          }
        }
      ]
    }
  }
};

final getArtistData = {
  "art": {
    "week": {
      "period": {"year": "2011", "week": "34"},
      "all": [
        {
          "id": "3ade68b7g98d71ea3",
          "name": "Bruno Mars",
          "url": "https://www.vagalume.com.br/bruno-mars/",
          "pic_small": "https://www.vagalume.com.br/bruno-mars/images/profile.jpg",
          "pic_medium": "https://www.vagalume.com.br/bruno-mars/images/bruno-mars.jpg",
          "uniques": "84709",
          "views": "183162"
        },
        {
          "id": "3ade68b7g98d71ea3",
          "name": "Bruno Mars",
          "url": "https://www.vagalume.com.br/bruno-mars/",
          "pic_small": "https://www.vagalume.com.br/bruno-mars/images/profile.jpg",
          "pic_medium": "https://www.vagalume.com.br/bruno-mars/images/bruno-mars.jpg",
          "uniques": "84709",
          "views": "183162"
        },
        {
          "id": "3ade68b7g98d71ea3",
          "name": "Bruno Mars",
          "url": "https://www.vagalume.com.br/bruno-mars/",
          "pic_small": "https://www.vagalume.com.br/bruno-mars/images/profile.jpg",
          "pic_medium": "https://www.vagalume.com.br/bruno-mars/images/bruno-mars.jpg",
          "uniques": "84709",
          "views": "183162"
        },
        {
          "id": "3ade68b7g98d71ea3",
          "name": "Bruno Mars",
          "url": "https://www.vagalume.com.br/bruno-mars/",
          "pic_small": "https://www.vagalume.com.br/bruno-mars/images/profile.jpg",
          "pic_medium": "https://www.vagalume.com.br/bruno-mars/images/bruno-mars.jpg",
          "uniques": "84709",
          "views": "183162"
        }
      ]
    }
  }
};
