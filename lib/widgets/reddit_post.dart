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
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 340,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 4),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(widget.post.subreddit, style: Theme.of(context).textTheme.caption,),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('u/${widget.post.author}', style: Theme.of(context).textTheme.caption,)
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: 180,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('S${widget.post.ups}', style: Theme.of(context).textTheme.headline6,),
                                          Text('C${widget.post.comments}', style: Theme.of(context).textTheme.headline6),
                                          Text('A${widget.post.awards}', style: Theme.of(context).textTheme.headline6),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ])
                      ],
                    ),
                    SizedBox(
                      height: 60,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30.0)),
                        child: widget.post.imageUrl.startsWith('https://')
                            ? Image.network(
                                widget.post.imageUrl,
                                fit: BoxFit.fitHeight,
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 10.0),
                  child: Text(
                    widget.post.title,
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
