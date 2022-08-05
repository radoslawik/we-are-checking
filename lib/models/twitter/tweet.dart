class Tweet {
  Tweet(
    this.title,
    this.id,
    this.authorId,
    this.authorName,
    this.timeCreated,
    this.likes,
  );

  final String title;
  final String id;
  final String authorId;
  final String authorName;
  final String timeCreated;
  final int likes;
}