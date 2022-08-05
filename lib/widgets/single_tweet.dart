import 'package:flutter/material.dart';
import 'package:hard_tyre/models/twitter/tweet.dart';

class TweetWidget extends StatefulWidget {
  const TweetWidget({Key? key, required this.tweet}) : super(key: key);
  final Tweet tweet;
  @override
  State<TweetWidget> createState() => _TweetWidgetState();
}

class _TweetWidgetState extends State<TweetWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: SizedBox(
        width: 350,
        height: 300,
        child: ListView(
          children: [
            Text(widget.tweet.authorName),
            Text(widget.tweet.timeCreated),
            Text(widget.tweet.title),
            Text(widget.tweet.likes.toString()),
          ],
        ),
      )
    );
  }
}