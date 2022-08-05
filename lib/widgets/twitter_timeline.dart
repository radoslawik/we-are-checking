import 'package:flutter/material.dart';
import 'package:hard_tyre/services/api/twitter_data_provider.dart';
import 'package:hard_tyre/widgets/single_tweet.dart';

class TwitterTimelineWidget extends StatefulWidget {
  const TwitterTimelineWidget({Key? key}) : super(key: key);

  @override
  State<TwitterTimelineWidget> createState() => _TwitterTimelineWidgetState();
}

class _TwitterTimelineWidgetState extends State<TwitterTimelineWidget> {
  List<TweetWidget> _tweets = List.empty();

  void initialize() async {
    final tweets = await TwitterDataProvider.getTweetTimeline();
    setState(() {
      _tweets = tweets.map((e) => TweetWidget(tweet: e)).toList();
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
        children: _tweets,
        )
      );
  }
}