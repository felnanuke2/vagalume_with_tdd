import 'package:flutter/material.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/controller/rank_controller.dart';
import 'package:transparent_image/transparent_image.dart';

class ArtistTab extends StatelessWidget {
  final _rankController = RankController();
  List<RankArtistModel> artistList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RankStreamStates>(
        stream: _rankController.rankArtistStream(vagalumeScope: VagalumeScope.Internacional),
        initialData: RankStreamComplet(rankList: _rankController.artistList),
        builder: (context, snapshotArtist) {
          if (snapshotArtist.data is RankStreamComplet) {
            artistList = List.from((snapshotArtist.data as RankStreamComplet).rankList);
          }

          if (artistList.isNotEmpty)
            return Padding(
              padding: EdgeInsets.all(8),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top 100 Artistas ',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1 / 1.5,
                    children: List.generate(
                        artistList.length,
                        (index) => Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: FadeInImage.memoryNetwork(
                                      imageErrorBuilder: (context, error, stackTrace) =>
                                          FlutterLogo(),
                                      placeholderScale: 0.5,
                                      image: artistList[index].image,
                                      fit: BoxFit.cover,
                                      placeholder: kTransparentImage,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  artistList[index].name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            )),
                  )
                ],
              ),
            );
          return Container();
        });
  }
}
