import 'dart:convert';

import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_music_entity.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';

class RankMusicModel extends RankMusicEntity {
  final String id;
  final String name;
  final String views;
  final RankArtistEntity artist;
  RankMusicModel({
    required this.id,
    required this.name,
    required this.views,
    required this.artist,
  }) : super(id: id, artist: artist, name: name, views: views);

  factory RankMusicModel.fromMap(Map<String, dynamic> map) {
    return RankMusicModel(
        id: map['id'],
        name: map['name'],
        views: map['views'],
        artist: RankArtistModel.fromMap(map['art']));
  }

  factory RankMusicModel.fromJson(String source) => RankMusicModel.fromMap(json.decode(source));
}
