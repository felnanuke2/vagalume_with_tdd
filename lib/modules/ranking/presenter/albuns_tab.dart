import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:genius_clean_arch/constants/constantColors.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_album_model.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_artist_model.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/controller/rank_controller.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/widgets/top_10_albuns_carousel.dart';
import 'package:transparent_image/transparent_image.dart';

class AlbunsTab extends StatefulWidget {
  @override
  _AlbunsTabState createState() => _AlbunsTabState();
}

class _AlbunsTabState extends State<AlbunsTab> with AutomaticKeepAliveClientMixin {
  RankController _rankController = RankController();

  List<RankAlbumModel> albunsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<RankStreamStates>(
            stream: _rankController.rankAlbunsStream(
                vagalumeScope: VagalumeScope.Internacional, maxItems: 100),
            initialData: RankStreamComplet(rankList: _rankController.albunsList),
            builder: (context, snapshotAlbuns) {
              if (snapshotAlbuns.data is RankStreamComplet) {
                albunsList = List.from((snapshotAlbuns.data as RankStreamComplet).rankList);
              }
              if (snapshotAlbuns.data is RankStreamComplet)
                return Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Top 10 Álbuns ',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Top10AlbunsCarousel(rankList: albunsList),
                      ],
                    ),
                    DraggableScrollableSheet(
                      initialChildSize: 0.2,
                      maxChildSize: 1,
                      minChildSize: 0.2,
                      builder: (context, scrollController) => Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(22), topRight: Radius.circular(22))),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: albunsList.length,
                                padding: EdgeInsets.all(8),
                                itemBuilder: (context, index) => Container(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(12),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: FadeInImage.memoryNetwork(
                                        imageErrorBuilder: (context, error, stackTrace) =>
                                            FlutterLogo(),
                                        placeholderScale: 0.5,
                                        image: albunsList[index].image,
                                        fit: BoxFit.cover,
                                        placeholder: kTransparentImage,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22)),
                                    tileColor: BACKGROUND_COLOR.withOpacity(1),
                                    title: RichText(
                                        text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: '${index + 1}º - ',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: albunsList[index].name,
                                            style: TextStyle(color: FONT_COLOR))
                                      ],
                                    )),
                                    subtitle: Text(
                                      albunsList[index].artist.name,
                                      style: TextStyle(color: FONT_COLOR),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              return Container();
            }));
  }

  @override
  bool get wantKeepAlive => true;
}
