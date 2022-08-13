import 'package:hard_tyre/models/media/media_item.dart';

class PlaygroundItem extends MediaItem {
  // TODO add props
  final String title;
  final Future<DetailedPlaygroundItem> Function() getData;

  PlaygroundItem(this.title, this.getData);
}

class DetailedPlaygroundItem {
  // TODO add props
}