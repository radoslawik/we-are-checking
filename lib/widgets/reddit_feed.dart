import 'package:flutter/material.dart';

import '../services/api/reddit_data_provider.dart';
import 'reddit_post.dart';


class RedditFeedWidget extends StatefulWidget {
  const RedditFeedWidget({Key? key}) : super(key: key);

  @override
  State<RedditFeedWidget> createState() => _RedditFeedWidgetState();
}

class _RedditFeedWidgetState extends State<RedditFeedWidget> {
  List<RedditPostWidget> _feed = List.empty();

  void initialize() async {
    final posts = await RedditDataProvider.getAllHotPosts();
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.reddit,
                size: 24.0,
              ),
              const SizedBox(width: 5.0),
              Text(
                'Reddit hot posts',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _feed,
              )
            ),
        ],
      ),
    );
  }
}