import 'package:hard_tyre/models/media/news_item.dart';
import 'package:collection/collection.dart';

class Tweet extends NewsItem {
  Tweet(this.rawObject, List<dynamic> media, String authorName) : super(rawObject["text"].toString(), authorName, DateTime.parse(rawObject["created_at"]))
  {
    id = rawObject["id"];
    title = title.replaceAll(RegExp(r'\n'), '').replaceAll(RegExp(r' 5️⃣'), ''); // Because it was crashing for some reason
    authorId = rawObject["author_id"];
    likes = rawObject["public_metrics"]["like_count"];
    retweet = rawObject["public_metrics"]["retweet_count"];
    reply = rawObject["public_metrics"]["reply_count"];
    final List<dynamic>? hsMap = rawObject["entities"]?["hashtags"];
    hashtags = hsMap != null ? hsMap.map((h) => '#${h["tag"]}').toList() : List.empty();
    final List<dynamic>? urlMap = rawObject["entities"]?["urls"];
    links = urlMap != null ? urlMap.map((u) => '${u["url"]}').toList() : List.empty();
    final List<dynamic>? mediaKeys = rawObject["attachments"]?["media_keys"];
    final String? mediaKey = mediaKeys?.firstOrNull;
    final mediaObject = media.where((m) => m["media_key"] == mediaKey).firstOrNull;
    final String? mediaUrl = mediaObject != null ? (mediaObject["type"] == "photo" ? mediaObject["url"] : mediaObject["type"] == "video" ? mediaObject["preview_image_url"] : null) : null;
    imageUrl = mediaUrl != null ? '$mediaUrl?format=jpg&name=240x240' : '';
    twitterUrl = 'https://twitter.com/$authorId/status/$id';
  }
  late String id;
  late String authorId;
  late int likes;
  late int retweet;
  late int reply;
  late List<String> hashtags;
  late List<String> links;
  late String twitterUrl;
  late String imageUrl;
  dynamic rawObject;
}