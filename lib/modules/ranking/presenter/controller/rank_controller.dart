import 'dart:async';
import 'package:dio/dio.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_album_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_music_entity.dart';

import 'package:genius_clean_arch/modules/ranking/domain/errors/rank_failuire.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_album_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_music_model.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/singletons/rank_singleton.dart';

class RankController {
  late RankSingleton _rankSingleton;
  List<RankMusicEntity> musicList = [];
  List<RankAlbumEntity> albunsList = [];
  List<RankArtistEntity> artistList = [];

  /// the optional dio is using for yours tests
  RankController({Dio? dio}) {
    _rankSingleton = RankSingleton.instance(dio: dio);
  }

  var _musicStream = StreamController<List<RankMusicEntity>>.broadcast();
  var _albumStream = StreamController<List<RankAlbumEntity>>.broadcast();
  var _artistStream = StreamController<List<RankArtistEntity>>.broadcast();

  Stream<RankStreamStates> rankMusicStream(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async* {
    yield RankStreamAwait(message: 'Recebendo o Rank do Vagalume');
    var result = await _rankSingleton.getRankMusics(
        dateTime: dateTime, maxItems: maxItems, vagalumeScope: vagalumeScope);
    yield result.fold((l) => RankStreamError(rankFailure: l), (r) {
      musicList = r;
      return RankStreamComplet(rankList: r);
    });
  }

  Stream<RankStreamStates> rankAlbunsStream(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async* {
    yield RankStreamAwait(message: 'Recebendo o Rank do Vagalume');
    var result = await _rankSingleton.getRankAlbuns(
        dateTime: dateTime, maxItems: maxItems, vagalumeScope: vagalumeScope);
    yield result.fold((l) => RankStreamError(rankFailure: l), (r) {
      albunsList = r;

      return RankStreamComplet(rankList: r);
    });
  }

  Stream<RankStreamStates> rankArtistStream(
      {VagalumeScope vagalumeScope = VagalumeScope.Nacional,
      int maxItems = 100,
      DateTime? dateTime}) async* {
    yield RankStreamAwait(message: 'Recebendo o Rank do Vagalume');
    var result = await _rankSingleton.getRankArtists(
        dateTime: dateTime, maxItems: maxItems, vagalumeScope: vagalumeScope);
    yield result.fold((l) => RankStreamError(rankFailure: l), (r) {
      artistList = r;
      return RankStreamComplet(rankList: r);
    });
  }
}

abstract class RankStreamStates {}

class RankStreamAwait extends RankStreamStates {
  final String message;
  RankStreamAwait({
    required this.message,
  });
}

class RankStreamComplet extends RankStreamStates {
  final List rankList;
  RankStreamComplet({
    required this.rankList,
  });
}

class RankStreamError extends RankStreamStates {
  final RankFailure rankFailure;
  RankStreamError({
    required this.rankFailure,
  });
}
