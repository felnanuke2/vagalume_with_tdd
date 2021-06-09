import 'package:flutter/material.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/albuns_tab.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/artist_tab.dart';
import 'package:genius_clean_arch/modules/ranking/presenter/music_tabs.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 58,
          ),
          TabBar(
              labelPadding: EdgeInsets.all(12),
              indicatorPadding: EdgeInsets.all(8),
              controller: tabController,
              tabs: [
                Text('Álbuns'),
                Text('Músicas'),
                Text('Artistas'),
              ]),
          Expanded(
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [AlbunsTab(), MusicTab(), ArtistTab()]))
        ],
      ),
    );
  }
}
