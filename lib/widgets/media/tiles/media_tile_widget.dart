import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/ergast/standings.dart';
import 'package:hard_tyre/models/media/media_tile.dart';
import 'package:hard_tyre/models/media/news_item.dart';
import 'package:hard_tyre/widgets/media/items/constructor_widget.dart';
import 'package:hard_tyre/widgets/media/items/driver_widget.dart';
import 'package:hard_tyre/widgets/media/items/media_item_widget.dart';
import 'package:hard_tyre/widgets/media/items/news_item_widget.dart';

class MediaTileWidget extends StatefulWidget {
  const MediaTileWidget({Key? key, required this.tile}) : super(key: key);
  final MediaTile tile;

  @override
  State<MediaTileWidget> createState() => _MediaTileWidgetState();
}

class _MediaTileWidgetState extends State<MediaTileWidget>
    with AutomaticKeepAliveClientMixin {
  List<MediaItemWidget> _feed = List.empty();
  bool _isLoading = true;

  void initialize() async {
    final medias = await widget.tile.getMedias();
    if (mounted) {
      setState(() {
        _feed = medias is List<NewsItem>
            ? medias.map((e) => NewsItemWidget(news: e)).toList()
            : medias is List<DriverStanding>
                ? medias.map((e) => DriverWidget(standing: e)).toList()
                : medias is List<ConstructorStanding>
                    ? medias.map((e) => ConstructorWidget(standing: e)).toList()
                    : [];
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void didUpdateWidget(covariant MediaTileWidget oldWidget) {
    _isLoading = true;
    super.didUpdateWidget(oldWidget);
    initialize();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                widget.tile.icon,
                size: 20.0,
              ),
              const SizedBox(width: 10.0),
              Text(
                widget.tile.title,
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(width: 10.0),
              widget.tile.showMore != null
                  ? MaterialButton(
                      onPressed: widget.tile.showMore,
                      child: Text(
                        'Show more...',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
              height: 150,
              child: _isLoading
                  ? const SizedBox(
                      width: 150,
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: CircularProgressIndicator(),
                      ))
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: _feed,
                    )),
        ],
      ),
    );
  }
}
