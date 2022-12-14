import 'package:hard_tyre/models/media/media_item.dart';

abstract class NewsItem extends MediaItem {
  NewsItem(this.title, this.authorName, this.timeCreated);
  late String title;
  final String authorName;
  final DateTime timeCreated;
}