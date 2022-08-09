import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/ergast/standings.dart';
import 'package:hard_tyre/models/media/media_item.dart';
import 'package:hard_tyre/models/media/news_item.dart';
import 'package:hard_tyre/widgets/media/items/constructor_widget.dart';
import 'package:hard_tyre/widgets/media/items/driver_widget.dart';
import 'package:hard_tyre/widgets/media/items/media_item_widget.dart';
import 'package:hard_tyre/widgets/media/items/news_item_widget.dart';


class MediaTileWidget extends StatefulWidget {
  const MediaTileWidget({Key? key, required this.title, required this.icon, required this.getMedias}) : super(key: key);
  final Future<List<MediaItem>> Function() getMedias;
  final String title;
  final IconData icon;

  @override
  State<MediaTileWidget> createState() => _MediaTileWidgetState();
}

class _MediaTileWidgetState extends State<MediaTileWidget> {
  List<MediaItemWidget> _feed = List.empty();

  void initialize() async {
    final medias = await widget.getMedias();
    setState(() {
      _feed = medias is List<NewsItem> ? medias.map((e) => NewsItemWidget(news: e)).toList() :
        medias is List<DriverStanding> ?  medias.map((e) => DriverWidget(standing: e)).toList() :
        medias is List<ConstructorStanding> ? medias.map((e) => ConstructorWidget(standing: e)).toList() : [];
    }); 
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                widget.icon,
                size: 24.0,
              ),
              const SizedBox(width: 5.0),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _feed,
              )
            ),
        ],
      ),
    );
  }
}