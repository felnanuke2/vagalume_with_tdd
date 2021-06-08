import 'dart:convert';

import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_album_entity.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';

class RankAlbumModel extends RankAlbumEntity {
  final String id;
  final String name;
  final String image;
  final String views;
  final RankArtistEntity artist;
  RankAlbumModel({
    required this.id,
    required this.name,
    required this.image,
    required this.views,
    required this.artist,
  }) : super(id: id, artist: artist, image: image, name: name, views: views);

  factory RankAlbumModel.fromMap(Map<String, dynamic> map) {
    return RankAlbumModel(
      id: map['id'],
      name: map['name'],
      image: map['cover'].toString().replaceAll('-W100', ''),
      views: map['views'].toString(),
      artist: RankArtistModel.fromMap(map['art']),
    );
  }
}
