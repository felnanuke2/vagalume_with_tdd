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
    "day": {
      "period": {"year": "2021", "day": "07", "month": "06"},
      "all": [
        {
          "id": "3ade68b8g4c07d0b3",
          "name": "Someone You Loved (tradução)",
          "url": "https://www.vagalume.com.br/lewis-capaldi/someone-you-loved-traducao.html",
          "uniques": "0",
          "views": "2041",
          "rank": "0.0",
          "art": {
            "id": "3ade68b7gc5c33ea3",
            "name": "Lewis Capaldi",
            "url": "https://www.vagalume.com.br/lewis-capaldi/",
            "pic_small": "https://s2.vagalume.com/lewis-capaldi/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/lewis-capaldi/images/lewis-capaldi.jpg"
          }
        },
        {
          "id": "3ade68b8gc05cf0b3",
          "name": "good 4 u (tradução)",
          "url": "https://www.vagalume.com.br/olivia-rodrigo/good-4-u-traducao.html",
          "uniques": "0",
          "views": "1903",
          "rank": "0.0",
          "art": {
            "id": "3ade68b7gd98d3ea3",
            "name": "Olivia Rodrigo",
            "url": "https://www.vagalume.com.br/olivia-rodrigo/",
            "pic_small": "https://s2.vagalume.com/olivia-rodrigo/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/olivia-rodrigo/images/olivia-rodrigo.jpg"
          }
        },
        {
          "id": "3ade68b5gf197eda3",
          "name": "Stand By Me (tradução)",
          "url": "https://www.vagalume.com.br/ben-e-king/stand-by-me-traducao.html",
          "uniques": "0",
          "views": "1341",
          "rank": "0.0",
          "art": {
            "id": "3ade68b4gf8a6eda3",
            "name": "Ben E. King",
            "url": "https://www.vagalume.com.br/ben-e-king/",
            "pic_small": "https://s2.vagalume.com/ben-e-king/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/ben-e-king/images/ben-e-king.jpg"
          }
        },
        {
          "id": "3ade68b8g98acf0b3",
          "name": "traitor (tradução)",
          "url": "https://www.vagalume.com.br/olivia-rodrigo/traitor-traducao.html",
          "uniques": "0",
          "views": "1327",
          "rank": "0.0",
          "art": {
            "id": "3ade68b7gd98d3ea3",
            "name": "Olivia Rodrigo",
            "url": "https://www.vagalume.com.br/olivia-rodrigo/",
            "pic_small": "https://s2.vagalume.com/olivia-rodrigo/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/olivia-rodrigo/images/olivia-rodrigo.jpg"
          }
        },
        {
          "id": "3ade68b8gf80540b3",
          "name": "Oração do Credo",
          "url": "https://www.vagalume.com.br/carlos-santorelli/oracao-do-credo.html",
          "uniques": "0",
          "views": "1188",
          "rank": "0.0",
          "art": {
            "id": "3ade68b7g059d1ea3",
            "name": "Carlos Santorelli",
            "url": "https://www.vagalume.com.br/carlos-santorelli/",
            "pic_small": "https://s2.vagalume.com/carlos-santorelli/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/carlos-santorelli/images/carlos-santorelli.jpg"
          },
          "albd": "O canto das orações",
          "alby": "2005",
          "alburl": "o-canto-das-oracoes"
        },
        {
          "id": "3ade68b8g2f79f0b3",
          "name": "deja vu (tradução)",
          "url": "https://www.vagalume.com.br/olivia-rodrigo/deja-vu-traducao.html",
          "uniques": "0",
          "views": "1159",
          "rank": "0.0",
          "art": {
            "id": "3ade68b7gd98d3ea3",
            "name": "Olivia Rodrigo",
            "url": "https://www.vagalume.com.br/olivia-rodrigo/",
            "pic_small": "https://s2.vagalume.com/olivia-rodrigo/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/olivia-rodrigo/images/olivia-rodrigo.jpg"
          }
        },
        {
          "id": "3ade68b8g5207e0b3",
          "name": "Save Your Tears (tradução)",
          "url": "https://www.vagalume.com.br/the-weeknd/save-your-tears-traducao.html",
          "uniques": "0",
          "views": "1152",
          "rank": "0.0",
          "art": {
            "id": "3ade68b7gf30e1ea3",
            "name": "The Weeknd",
            "url": "https://www.vagalume.com.br/the-weeknd/",
            "pic_small": "https://s2.vagalume.com/the-weeknd/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/the-weeknd/images/the-weeknd.jpg"
          }
        },
        {
          "id": "3ade68b8g1218efa3",
          "name": "A Thousand Years (tradução)",
          "url": "https://www.vagalume.com.br/christina-perri/a-thousand-years-traducao.html",
          "uniques": "0",
          "views": "1143",
          "rank": "0.0",
          "art": {
            "id": "3ade68b7gee7a1ea3",
            "name": "Christina Perri",
            "url": "https://www.vagalume.com.br/christina-perri/",
            "pic_small": "https://s2.vagalume.com/christina-perri/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/christina-perri/images/christina-perri.jpg"
          }
        },
        {
          "id": "3ade68b8g517bf0b3",
          "name": "Girl From Rio (tradução)",
          "url": "https://www.vagalume.com.br/anitta/girl-from-rio-traducao.html",
          "uniques": "0",
          "views": "1117",
          "rank": "0.0",
          "art": {
            "id": "3ade68b7gc8cb1ea3",
            "name": "Anitta",
            "url": "https://www.vagalume.com.br/anitta/",
            "pic_small": "https://s2.vagalume.com/anitta/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/anitta/images/anitta.jpg"
          }
        },
        {
          "id": "3ade68b8gbb0f0fa3",
          "name": "Oficio da Imaculada Conceição",
          "url": "https://www.vagalume.com.br/cancao-nova/oficio-da-imaculada-conceicao.html",
          "uniques": "0",
          "views": "1078",
          "rank": "0.0",
          "art": {
            "id": "3ade68b5g8b38eda3",
            "name": "Canção Nova",
            "url": "https://www.vagalume.com.br/cancao-nova/",
            "pic_small": "https://s2.vagalume.com/cancao-nova/images/profile.jpg",
            "pic_medium": "https://s2.vagalume.com/cancao-nova/images/cancao-nova.jpg"
          }
        }
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
    "day": {
      "period": {"year": "2021", "day": "07", "month": "06"},
      "nacional": [
        {
          "id": "3ade68b6gad13fda3",
          "name": "Harpa Cristã",
          "url": "https://www.vagalume.com.br/harpa-crista/",
          "pic_small": "https://s2.vagalume.com/harpa-crista/images/profile.jpg",
          "pic_medium": "https://s2.vagalume.com/harpa-crista/images/harpa-crista.jpg",
          "uniques": "0",
          "views": "2858",
          "rank": "0.0"
        },
        {
          "id": "3ade68b7gc8cb1ea3",
          "name": "Anitta",
          "url": "https://www.vagalume.com.br/anitta/",
          "pic_small": "https://s2.vagalume.com/anitta/images/profile.jpg",
          "pic_medium": "https://s2.vagalume.com/anitta/images/anitta.jpg",
          "uniques": "0",
          "views": "2284",
          "rank": "0.0"
        },
        {
          "id": "3ade68b5g3758eda3",
          "name": "Roberto Carlos",
          "url": "https://www.vagalume.com.br/roberto-carlos/",
          "pic_small": "https://s2.vagalume.com/roberto-carlos/images/profile.jpg",
          "pic_medium": "https://s2.vagalume.com/roberto-carlos/images/roberto-carlos.jpg",
          "uniques": "0",
          "views": "1796",
          "rank": "0.0"
        },
        {
          "id": "3ade68b5g5fe8eda3",
          "name": "Zezé Di Camargo e Luciano",
          "url": "https://www.vagalume.com.br/zeze-di-camargo-e-luciano/",
          "pic_small": "https://s2.vagalume.com/zeze-di-camargo-e-luciano/images/profile.jpg",
          "pic_medium":
              "https://s2.vagalume.com/zeze-di-camargo-e-luciano/images/zeze-di-camargo-e-luciano.jpg",
          "uniques": "0",
          "views": "1608",
          "rank": "0.0"
        },
        {
          "id": "3ade68b7g059d1ea3",
          "name": "Carlos Santorelli",
          "url": "https://www.vagalume.com.br/carlos-santorelli/",
          "pic_small": "https://s2.vagalume.com/carlos-santorelli/images/profile.jpg",
          "pic_medium": "https://s2.vagalume.com/carlos-santorelli/images/carlos-santorelli.jpg",
          "uniques": "0",
          "views": "1369",
          "rank": "0.0"
        },
        {
          "id": "3ade68b7g56470ea3",
          "name": "Músicas Católicas",
          "url": "https://www.vagalume.com.br/musicas-catolicas/",
          "pic_small": "https://s2.vagalume.com/musicas-catolicas/images/profile.jpg",
          "pic_medium": "https://s2.vagalume.com/musicas-catolicas/images/musicas-catolicas.jpg",
          "uniques": "0",
          "views": "1263",
          "rank": "0.0"
        },
        {
          "id": "3ade68b7ga2553ea3",
          "name": "Kamaitachi",
          "url": "https://www.vagalume.com.br/kamaitachi/",
          "pic_small": "https://s2.vagalume.com/kamaitachi/images/profile.jpg",
          "pic_medium": "https://s2.vagalume.com/kamaitachi/images/kamaitachi.jpg",
          "uniques": "0",
          "views": "1234",
          "rank": "0.0"
        },
        {
          "id": "3ade68b7g92052ea3",
          "name": "Mc Livinho",
          "url": "https://www.vagalume.com.br/mc-livinho/",
          "pic_small": "https://s2.vagalume.com/mc-livinho/images/profile.jpg",
          "pic_medium": "https://s2.vagalume.com/mc-livinho/images/mc-livinho.jpg",
          "uniques": "0",
          "views": "1194",
          "rank": "0.0"
        },
        {
          "id": "3ade68b5g8b38eda3",
          "name": "Canção Nova",
          "url": "https://www.vagalume.com.br/cancao-nova/",
          "pic_small": "https://s2.vagalume.com/cancao-nova/images/profile.jpg",
          "pic_medium": "https://s2.vagalume.com/cancao-nova/images/cancao-nova.jpg",
          "uniques": "0",
          "views": "1134",
          "rank": "0.0"
        },
        {
          "id": "3ade68b6g9609eda3",
          "name": "Racionais Mc's",
          "url": "https://www.vagalume.com.br/racionais-mcs/",
          "pic_small": "https://s2.vagalume.com/racionais-mcs/images/profile.jpg",
          "pic_medium": "https://s2.vagalume.com/racionais-mcs/images/racionais-mcs.jpg",
          "uniques": "0",
          "views": "1114",
          "rank": "0.0"
        }
      ]
    }
  }
};
