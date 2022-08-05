import 'package:flutter/material.dart';
import '../models/reddit/post.dart';

class RedditPostWidget extends StatefulWidget {
  const RedditPostWidget({Key? key, required this.post}) : super(key: key);
  final RedditPost post;
  @override
  State<RedditPostWidget> createState() => _RedditPostWidgetState();
}

class _RedditPostWidgetState extends State<RedditPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: SizedBox(
        width: 350,
        height: 400,
        child: ListView(
          children: [
            widget.post.imageUrl != 'self' ? Image.network(widget.post.imageUrl, height: 100) : Container(),
            Text(widget.post.title),
            Text(widget.post.author),
            Text(widget.post.subreddit),
            Text(widget.post.comments.toString()),
          ],
        ),
      )
    );
  }
}