import 'package:hard_tyre/models/media/news_item.dart';

class Tweet extends NewsItem {
  Tweet(
    title,
    authorName,
    timeCreated,
    this.id,
    this.authorId,
    this.likes,
    this.retweet,
    this.reply,
  ) : super(title, authorName, timeCreated);

  final String id;
  final String authorId;
  final int likes;
  final int retweet;
  final int reply;
}