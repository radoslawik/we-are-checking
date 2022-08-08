import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/reddit/post.dart';

class RedditPostWidget extends StatefulWidget {
  const RedditPostWidget({Key? key, required this.post}) : super(key: key);
  final RedditPost post;

  @override
  State<RedditPostWidget> createState() => _RedditPostWidgetState();
}

class _RedditPostWidgetState extends State<RedditPostWidget> {
  final _scoreThresholds = [5000, 10000];
  final _commentThresholds = [500, 1000];
  final _awardThresholds = [5, 10];
  final _thColors = [Colors.green.shade700, Colors.orange.shade700];

  String getTimeAgo(double ts){
    var timeCreated = DateTime.fromMillisecondsSinceEpoch(ts.toInt()*1000);
    var timeAgo = DateTime.now().difference(timeCreated);
    return timeAgo.inHours.toString();
  }
  String formatNumber(int num){
    return num > 1000 ? '${num~/1000}k': num.toString(); 
  }

  Color getIndicatorColor(int num, List<int> th){
    var ind = num > th.elementAt(1) ? 1 : num > th.elementAt(0) ? 0 : -1;
    return ind != -1 ? _thColors.elementAt(ind) : Colors.black87;
  }

  void openUrl() async {
    final url = Uri.parse(widget.post.redditUrl);
    await launchUrl(url);
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
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.keyboard_double_arrow_up_rounded,
                                color: getIndicatorColor(widget.post.ups, _scoreThresholds),
                                size: 16.0,
                              ),
                              Text(
                                formatNumber(widget.post.ups),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.comment,
                                color: getIndicatorColor(widget.post.comments, _commentThresholds),
                                size: 16.0,
                              ),
                              Text(
                                formatNumber(widget.post.comments),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.celebration_rounded,
                                color: getIndicatorColor(widget.post.awards, _awardThresholds),
                                size: 16.0,
                              ),
                              Text(
                                '${widget.post.awards}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: widget.post.imageUrl.startsWith('https://')
                              ? 220
                              : 300,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.post.subreddit,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                Text(
                                  'u/${widget.post.author}',
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                widget.post.title,
                                style: Theme.of(context).textTheme.subtitle1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                widget.post.sourceUrl ?? "",
                                style: Theme.of(context).textTheme.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.post.imageUrl.startsWith('https://')
                        ? Image.network(
                            widget.post.imageUrl,
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
                        child: Text('${getTimeAgo(widget.post.timeCreated)}h ago',
                        style: Theme.of(context).textTheme.caption,),
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
