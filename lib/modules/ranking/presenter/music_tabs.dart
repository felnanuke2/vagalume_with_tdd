import 'package:flutter/material.dart';
import 'package:genius_clean_arch/constants/constantColors.dart';
import 'package:genius_clean_arch/modules/ranking/domain/repository/rank_repository.dart';
import 'package:genius_clean_arch/modules/ranking/infra/models/rank_music_model.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/controller/rank_controller.dart';

class MusicTab extends StatelessWidget {
  RankController _rankController = RankController();
  List<RankMusicModel> musicList = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<RankStreamStates>(
          stream: _rankController.rankMusicStream(vagalumeScope: VagalumeScope.Internacional),
          initialData: RankStreamComplet(rankList: _rankController.musicList),
          builder: (context, snapshotMusics) {
            if (snapshotMusics.data is RankStreamComplet) {
              musicList = List.from((snapshotMusics.data as RankStreamComplet).rankList);
            }
            if (musicList.isNotEmpty)
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top 100 Músicas ',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: musicList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ACCET_COLOR,
                          child: Text(
                            '${index + 1}º',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        title: Text(
                          musicList[index].name,
                          style: TextStyle(color: FONT_COLOR),
                        ),
                        subtitle: Text(
                          musicList[index].artist.name,
                          style: TextStyle(color: FONT_COLOR),
                        ),
                        trailing: Column(
                          children: [
                            Icon(
                              Icons.visibility,
                              color: ACCET_COLOR,
                            ),
                            Text(
                              musicList[index].views,
                              style: TextStyle(color: FONT_COLOR),
                            ),
                          ],
                        ),
                      );
                    },
                  ))
                ],
              );
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
