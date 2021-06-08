import 'package:equatable/equatable.dart';
import 'package:genius_clean_arch/modules/ranking/domain/entity/rank_artist_entity.dart';

class RankMusicEntity extends Equatable {
  final String id;
  final String name;
  final String views;
  final RankArtistEntity artist;

  RankMusicEntity({
    required this.id,
    required this.name,
    required this.views,
    required this.artist,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, views, artist];
}
