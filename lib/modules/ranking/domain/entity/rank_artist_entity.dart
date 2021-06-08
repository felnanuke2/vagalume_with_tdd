import 'package:equatable/equatable.dart';

class RankArtistEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  String? views;
  RankArtistEntity({required this.id, required this.name, required this.image, this.views});

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, image, views];
}
