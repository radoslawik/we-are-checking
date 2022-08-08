import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import '../../models/twitter/tweet.dart';

class TwitterDataProvider {

    static const String _endpoint = 'https://api.twitter.com/2';
    static const String _token = 'AAAAAAAAAAAAAAAAAAAAANp%2BfgEAAAAAe52687UpZHtt9p3xT86JwT%2BpMS8%3DVuSGpLPq7M726pfWOKBHqTzWlxpb15GO4GZ33pOaWP1PUy2gBR';
    static const _headers = {
      'authorization': 'Bearer $_token',
      'user-agent': 'windows:com.example.wearechecking:v0.0.1 (by @radoslawik)',
    };
    static const List<String> _usernames = ["F1", "redbullracing", "ScuderiaFerrari", "MercedesAMGF1",
      "AlpineF1Team", "McLarenF1", "HaasF1Team", "AlphaTauriF1", "AstonMartinF1", "alfaromeoorlen", "WilliamsRacing"];
    static final Map<String,String> _userIds = {};
    static final List<Tweet> _tweets = [];

    static Future<void> _getUserIds() async {
      final response = await http.get(Uri.parse("$_endpoint/users/by?usernames=${_usernames.join(',')}"), headers: _headers);
      if(response.statusCode == 200)
      {
        List<dynamic> decoded = jsonDecode(response.body)["data"];
        for (var e in decoded)
        {
          _userIds[e["username"].toString()] = e["id"].toString();
        }
      }
    }

    static Future<List<Tweet>> _getUserTweets(String id) async {
      final response = await http.get(Uri.parse("$_endpoint/users/$id/tweets?tweet.fields=author_id,created_at,public_metrics,conversation_id,entities,lang&expansions=attachments.media_keys&media.fields=preview_image_url,url&max_results=10"), headers: _headers);
      if(response.statusCode == 200)
      {
        List<dynamic> decoded = jsonDecode(response.body)["data"].where((e) => e["id"] == e["conversation_id"]).toList();
        return decoded.map((e) => Tweet(e["text"], e["id"], e["author_id"], _userIds.keys.firstWhereOrNull((k) => _userIds[k] == e['author_id']) ?? "Unknown",
         e["created_at"], e["public_metrics"]["like_count"], e["public_metrics"]["retweet_count"], e["public_metrics"]["reply_count"])).toList();

      }
      return List.empty();
    }

    static Future<List<Tweet>> getTweetTimeline() async {
      if(_userIds.isEmpty)
      {
        await _getUserIds();
      }
      for(var id in _userIds.values)
      {
        _tweets.addAll(await _getUserTweets(id));
      }
      if(_tweets.isNotEmpty)
      {
        _tweets.sort((a,b) => int.parse(b.id).compareTo(int.parse(a.id)));
      }
      return _tweets.take(10).toList();
    }
}