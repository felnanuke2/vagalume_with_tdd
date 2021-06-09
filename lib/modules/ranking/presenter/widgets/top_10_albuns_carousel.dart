import 'dart:async';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:genius_clean_arch/modules/ranking/domain/usecases/get_rank_albuns.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_album_model.dart';
import 'package:transparent_image/transparent_image.dart';

class Top10AlbunsCarousel extends StatelessWidget {
  Top10AlbunsCarousel({
    required this.rankList,
  });

  final List<RankAlbumModel> rankList;
  var position = 0.0;
  final _indexController = StreamController<int>.broadcast();

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        viewportFraction: 0.65,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enlargeCenterPage: true,
        aspectRatio: 4 / 4,
        disableCenter: true,
        autoPlay: true,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) => Container(
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: FadeInImage.memoryNetwork(
                    image: rankList[index].image,
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                  )),
            ),

            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    rankList[index].name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    rankList[index].artist.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   left: 15,
            //   top: 10,
            //   bottom: 0,
            //   child: Text(
            //     '${index + 1}º',
            //     style: TextStyle(
            //         fontWeight: FontWeight.bold, fontSize: 22, fontStyle: FontStyle.italic),
            //   ),
            // ),
            // Positioned(
            //   top: 10,
            //   bottom: 0,
            //   right: 15,
            //   child: Text(
            //     '${rankList[index].views}\n Views',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         fontWeight: FontWeight.bold, fontSize: 16, fontStyle: FontStyle.italic),
            //   ),
            // )
          ],
        ),
      ),
      itemCount: 10,
    );
  }
}
