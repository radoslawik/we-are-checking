class Tweet {
  Tweet(
    this.title,
    this.id,
    this.authorId,
    this.authorName,
    this.timeCreated,
    this.likes,
    this.retweet,
    this.reply,
  );

  final String title;
  final String id;
  final String authorId;
  final String authorName;
  final String timeCreated;
  final int likes;
  final int retweet;
  final int reply;
}