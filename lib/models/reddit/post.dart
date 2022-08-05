class RedditPost {
  RedditPost(
    this.title,
    this.imageUrl,
    this.subreddit,
    this.author,
    this.timeCreated,
    this.comments,
  );

  final String title;
  final String imageUrl;
  final String subreddit;
  final String author;
  final double timeCreated;
  final int comments;
}