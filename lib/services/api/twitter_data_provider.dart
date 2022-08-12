import 'dart:convert';
import 'package:hard_tyre/models/data/twitter/tweet.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import '../../helpers/constants.dart';

class TwitterDataProvider {
  static const String _endpoint = 'https://api.twitter.com/2';
  static const String _token =
      'AAAAAAAAAAAAAAAAAAAAANp%2BfgEAAAAAe52687UpZHtt9p3xT86JwT%2BpMS8%3DVuSGpLPq7M726pfWOKBHqTzWlxpb15GO4GZ33pOaWP1PUy2gBR';
  static const _headers = {
    'authorization': 'Bearer $_token',
    'user-agent': Constants.userAgent,
  };
  static const List<String> usernames = [
    "F1",
    "redbullracing",
    "ScuderiaFerrari",
    "MercedesAMGF1",
    "AlpineF1Team",
    "McLarenF1",
    "HaasF1Team",
    "AlphaTauriF1",
    "AstonMartinF1",
    "alfaromeoorlen",
    "WilliamsRacing"
  ];
  static final Map<String, String> _userIds = {};
  static final List<Tweet> _tweets = [];
  static final Map<String, List<Tweet>> _tweetsMap = {};

  static Future<void> _getUserIds() async {
    final response = await http.get(
        Uri.parse("$_endpoint/users/by?usernames=${usernames.join(',')}"),
        headers: _headers);
    if (response.statusCode == 200) {
      List<dynamic> decoded = jsonDecode(response.body)["data"];
      for (var e in decoded) {
        _userIds[e["username"].toString()] = e["id"].toString();
      }
    }
  }

  static Future<List<Tweet>> getUserTweets(String name,
      [bool forceRefresh = false]) async {
    final previous = _tweetsMap[name];
    if (forceRefresh || previous == null) {
      final id = _userIds[name];
      final response = await http.get(
          Uri.parse(
              "$_endpoint/users/$id/tweets?tweet.fields=attachments,author_id,created_at,public_metrics,conversation_id,entities,lang&expansions=attachments.media_keys&media.fields=preview_image_url,url&max_results=100"),
          headers: _headers);
      if (response.statusCode == 200) {
        dynamic decoded = jsonDecode(response.body);
        List<dynamic> media = decoded["includes"]?["media"] ?? [];
        List<dynamic> decodedData = decoded["data"]
            .where((e) => e["id"] == e["conversation_id"])
            .toList();
        return decodedData
            .map((e) => Tweet(e, media, _userIds.keys.firstWhereOrNull((k) => _userIds[k] == e['author_id']) ?? "Unknown"))
            .toList();
      }
    }
    return previous?.take(10).toList() ?? List.empty();
  }

  static Future<List<Tweet>> getTweetTimeline([bool forceRefresh = false]) async {
    if(forceRefresh || _tweets.isEmpty){
      if (_userIds.isEmpty) {
        await _getUserIds();
      }
      for (var name in _userIds.keys) {
        var userTweets = await getUserTweets(name);
        _tweetsMap[name] = userTweets.where((p) => DateTime.now().difference(p.timeCreated).inDays < 30).toList();
        _tweets.addAll(_tweetsMap[name]!);
      }
      if (_tweets.isNotEmpty) {
        _tweets.sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));
      }
    }
    return _tweets.take(20).toList();
  }
}
