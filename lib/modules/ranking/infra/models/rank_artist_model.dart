import 'dart:convert';

import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';

class RankArtistModel extends RankArtistEntity {
  final String id;
  final String name;
  final String image;
  String? views;

  RankArtistModel({
    required this.id,
    required this.name,
    required this.image,
    this.views,
  }) : super(id: id, image: image, name: name, views: views);

  factory RankArtistModel.fromMap(Map<String, dynamic> map) {
    return RankArtistModel(
      id: map['id'],
      name: map['name'],
      image: map['pic_medium'],
      views: map['views'],
    );
  }
  factory RankArtistModel.fromJson(String source) => RankArtistModel.fromMap(json.decode(source));
}
