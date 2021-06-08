import 'package:equatable/equatable.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';

class RankAlbumEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final String views;
  final RankArtistEntity artist;
  RankAlbumEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.artist,
    required this.views,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, image, views];
}
