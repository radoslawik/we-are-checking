import 'package:flutter/material.dart';
import 'package:hard_tyre/models/media/media_tile.dart';
import 'package:hard_tyre/widgets/tiles/media_tile_widget.dart';
import 'package:hard_tyre/widgets/title_bar_widget.dart';

class MainContentWidget extends StatefulWidget {
  const MainContentWidget({Key? key, required this.medias}) : super(key: key);
  final List<MediaTile> medias;

  @override
  State<MainContentWidget> createState() => _MainContentWidgetState();
}

class _MainContentWidgetState extends State<MainContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const TitleBarWidget(),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 16.0),
            child: ListView(
                physics: const BouncingScrollPhysics(),
                children: widget.medias
                    .map((e) => MediaTileWidget(tile: e))
                    .toList(growable: false))));
  }
}
