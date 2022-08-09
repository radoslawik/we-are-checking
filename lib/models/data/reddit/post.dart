import 'package:hard_tyre/models/media/news_item.dart';

class RedditPost extends NewsItem {
  RedditPost(this.rawObject) : super(rawObject["title"], rawObject["author"], _timestampToDate(rawObject["created_utc"]))
  {
    imageUrl = rawObject["thumbnail"];
    subreddit = rawObject["subreddit_name_prefixed"];
    comments = rawObject["num_comments"];
    ups = rawObject["ups"];
    awards = rawObject["total_awards_received"];
    redditUrl = "www.reddit.com${rawObject["permalink"]}";
    sourceUrl = rawObject["url"];
  }

  late String imageUrl;
  late String subreddit;
  late int comments;
  late int ups;
  late int awards;
  late String redditUrl;
  late String sourceUrl;
  dynamic rawObject;

  static DateTime _timestampToDate(double ts){
    return DateTime.fromMillisecondsSinceEpoch(ts.toInt()*1000);
  }

}