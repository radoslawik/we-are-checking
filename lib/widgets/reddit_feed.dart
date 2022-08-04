import 'package:flutter/material.dart';

import '../services/reddit_data_provider.dart';
import 'reddit_post.dart';


class RedditFeedWidget extends StatefulWidget {
  const RedditFeedWidget({Key? key}) : super(key: key);

  @override
  State<RedditFeedWidget> createState() => _RedditFeedWidgetState();
}

class _RedditFeedWidgetState extends State<RedditFeedWidget> {
  List<RedditPostWidget> _feed = List.empty();

  void initialize() async {
    final posts = await RedditDataProvider.getHotPosts();
    setState(() {
      _feed = posts.map((e) => RedditPostWidget(post: e)).toList();
    }); 
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _feed,
        )
      );
  }
}