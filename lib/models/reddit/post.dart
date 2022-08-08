class RedditPost {
  RedditPost(
    this.title,
    this.imageUrl,
    this.subreddit,
    this.author,
    this.timeCreated,
    this.comments,
    this.ups,
    this.awards,
    this.redditUrl,
    this.sourceUrl,
  );

  final String title;
  final String imageUrl;
  final String subreddit;
  final String author;
  final double timeCreated;
  final int comments;
  final int ups;
  final int awards;
  final String redditUrl;
  final String? sourceUrl;
}