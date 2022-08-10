import 'package:flutter/material.dart';
import 'media_item.dart';

class MediaTile {
  MediaTile(this.title, this.icon, this.getMedias, this.showMore);
  final String title;
  final IconData icon;
  final Future<List<MediaItem>> Function() getMedias;
  final Function()? showMore;
}