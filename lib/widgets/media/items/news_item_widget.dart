import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hard_tyre/models/data/reddit/post.dart';
import 'package:hard_tyre/models/data/twitter/tweet.dart';
import 'package:hard_tyre/models/media/news_item.dart';
import 'package:hard_tyre/widgets/media/helpers/caption_widget.dart';
import 'package:hard_tyre/widgets/media/helpers/indicator_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'media_item_widget.dart';

class NewsItemWidget extends MediaItemWidget {
  const NewsItemWidget({Key? key, required this.news}) : super(key: key);
  final NewsItem news;

  @override
  State<NewsItemWidget> createState() => _NewsItemWidgetState();
}

class _NewsItemWidgetState extends State<NewsItemWidget> {
  final _scoreThresholds = [5000, 10000];
  final _commentThresholds = [500, 1000];
  final _awardThresholds = [5, 10];
  final _thColors = [Colors.green.shade700, Colors.orange.shade700];

  late List<CaptionWidget> _topCaptions;
  late List<CaptionWidget> _bottomCaptions;
  late List<IndicatorWidget> _indicators;
  late String _imageUrl;
  late String _newsUrl;

  @override
  void initState() {
    super.initState();
    if(widget.news is RedditPost){
      final post = widget.news as RedditPost;
      _topCaptions = [ post.subreddit, 'u/${post.authorName}' ].map((e) => CaptionWidget(text: e)).toList();
      _bottomCaptions = [ CaptionWidget(text: post.sourceUrl) ];
      _indicators = [
        IndicatorWidget(iconData: Icons.keyboard_double_arrow_up_rounded,
         number: post.ups, thresholds: _scoreThresholds, colors: _thColors),
        IndicatorWidget(iconData: Icons.comment_rounded,
         number: post.comments, thresholds: _commentThresholds, colors: _thColors),
        IndicatorWidget(iconData: Icons.celebration_rounded,
         number: post.awards, thresholds: _awardThresholds, colors: _thColors),
      ];
      _imageUrl = post.imageUrl;
      _newsUrl = post.redditUrl;
    }
    else if(widget.news is Tweet)
    {
      final tweet = widget.news as Tweet;
      _topCaptions = [ CaptionWidget(text: tweet.authorName) ];
      _bottomCaptions = [];
      if(tweet.links.isNotEmpty){
        _bottomCaptions.add(CaptionWidget(text: tweet.links.first));
      }
      if(tweet.hashtags.isNotEmpty){
        _bottomCaptions.add(CaptionWidget(text: tweet.hashtags.first));
      }
      _indicators = [
        IndicatorWidget(iconData: Icons.keyboard_double_arrow_up_rounded,
         number: tweet.likes, thresholds: _scoreThresholds, colors: _thColors),
        IndicatorWidget(iconData: Icons.comment_rounded,
         number: tweet.retweet, thresholds: _commentThresholds, colors: _thColors),
        IndicatorWidget(iconData: Icons.celebration_rounded,
         number: tweet.reply, thresholds: _awardThresholds, colors: _thColors),
      ];
      _imageUrl = tweet.imageUrl;
      _newsUrl = tweet.twitterUrl;
    }
  }

  String getTimeAgo(){
    var timeAgo = DateTime.now().difference(widget.news.timeCreated);
    return timeAgo.inHours.toString();
  }
  
  void openUrl() async {
    if(_newsUrl != '')
    {
      final url = Uri.parse(_newsUrl);
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: MaterialButton(
            onPressed: openUrl,
            padding: EdgeInsets.zero,
            color: Colors.white,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _indicators
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: _imageUrl.startsWith('https://')
                              ? 220
                              : 300,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _topCaptions
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                widget.news.title,
                                style: Theme.of(context).textTheme.subtitle1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: _imageUrl.startsWith('https://') ? 0 : 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: _bottomCaptions
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _imageUrl.startsWith('https://')
                        ? Image.network(
                            _imageUrl,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ],
                ),
                Positioned(
                    right: 0.0,
                    bottom: 20.0,
                    child: Container(
                      color: Colors.white60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text('${getTimeAgo()}h ago',
                        style: Theme.of(context).textTheme.caption),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
