import 'package:hard_tyre/models/media/news_item.dart';

class RedditPost extends NewsItem {
  RedditPost(
    title,
    author,
    timeCreated,
    this.imageUrl,
    this.subreddit,
    this.comments,
    this.ups,
    this.awards,
    this.redditUrl,
    this.sourceUrl,
  ) : super(title, author, timeCreated);

  final String imageUrl;
  final String subreddit;
  final int comments;
  final int ups;
  final int awards;
  final String redditUrl;
  final String? sourceUrl;
}