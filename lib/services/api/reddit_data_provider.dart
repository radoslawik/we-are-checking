import 'dart:convert';
import 'package:hard_tyre/helpers/constants.dart';
import 'package:hard_tyre/models/data/reddit/post.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class RedditDataProvider {
  static const String _basicAuth = 'Basic R29uWWFMTW9nZ09pTjB5Wl9Fa2FlZzo=';
  static const String _endpoint = 'https://oauth.reddit.com';
  static const subreddits = ["formula1", "formuladank", "F1Technical", "F1FeederSeries", "GrandPrixRacing"];
  static String? _token;
  static final Map<String, List<RedditPost>> _postMap = {};
  static final List<RedditPost> _hotPosts = [];

  static Future<String?> _getAccessToken() async {
    final headers = {
      'authorization': _basicAuth,
      'user-agent': Constants.userAgent,
    };
    final body = {
      'grant_type': '$_endpoint/grants/installed_client',
      'device_id': const Uuid().v4(),
    };
    final response = await http.post(
        Uri.parse("https://www.reddit.com/api/v1/access_token"),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey("access_token")) {
        return responseBody["access_token"];
      }
    }
    return null;
  }

  static Future<List<RedditPost>> getAllHotPosts(
      [bool forceRefresh = false]) async {
    if (forceRefresh || _hotPosts.isEmpty) {
      _token ??= await _getAccessToken();
      if (_token != null) {
        for (var sub in subreddits) {
          var posts = await getHotPosts(sub);
          _postMap[sub] = posts.where((p) => DateTime.now().difference(p.timeCreated).inDays < 30).toList();
          _hotPosts.addAll(_postMap[sub]!);
        }
        _hotPosts.sort((a, b) => b.ups.compareTo(a.ups));
      }
    }
    return _hotPosts.take(15).toList();
  }

  static Future<List<RedditPost>> getHotPosts(String subreddit,
      [bool forceRefresh = false]) async {
    if (!forceRefresh && _postMap[subreddit] is List<RedditPost>) {
      return _postMap[subreddit] as List<RedditPost>;
    }

    final headers = {
      'authorization': 'Bearer $_token',
      'user-agent': Constants.userAgent,
    };
    final response = await http.get(
        Uri.parse("$_endpoint/r/$subreddit/hot?limit=15"),
        headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> postsInfo = jsonDecode(response.body)["data"]["children"];
      return postsInfo
          .map((e) => e["data"])
          .map((d) => RedditPost(d))
          .toList();
    }
    return List.empty();
  }

  static Map<String, List<RedditPost>> getGroupedHotPosts() {
    return _postMap;
  }
}
