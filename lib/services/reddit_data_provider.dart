import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../models/reddit.dart';

class RedditDataProvider {
  static const String _basicAuth = 'Basic R29uWWFMTW9nZ09pTjB5Wl9Fa2FlZzo=';
  static const String _userAgent = 'windows:com.example.wearechecking:v0.0.1 (by /u/Hanyanhisi)';
  static const String _endpoint = 'https://oauth.reddit.com';
  static String? _token;
  static List<RedditPost>? _posts;

  static Future<String?> _getAccessToken() async {
    final headers = {
      'authorization': _basicAuth,
      'user-agent': _userAgent,
    };
    final body = {
      'grant_type': '$_endpoint/grants/installed_client',
      'device_id': const Uuid().v4(),
    };
    final response = await http.post(Uri.parse("https://www.reddit.com/api/v1/access_token"), headers: headers, body: body);

    if(response.statusCode == 200)
    {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if(responseBody.containsKey("access_token"))
      {
        return responseBody["access_token"];
      }
    }
    return null;
  }

  static Future<List<RedditPost>> getHotPosts() async {
    _token ??= await _getAccessToken();
    if(_posts == null || _token != null)
    {
      final headers = {
        'authorization': 'Bearer $_token',
        'user-agent': _userAgent,
      };
      final response = await http.get(Uri.parse("$_endpoint/r/formula1/hot"), headers: headers);

      if(response.statusCode == 200)
      {
        List<dynamic> postsInfo = jsonDecode(response.body)["data"]["children"];
        _posts = postsInfo.map((e) => e["data"]).map((d) =>
          RedditPost(d["title"], d["thumbnail"], d["subreddit_name_prefixed"], d["author"], d["created_utc"], d["num_comments"])).toList();
      }
    }
    return _posts ?? List.empty();
  }

}