import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hard_tyre/helpers/constants.dart';

class CacheProvider extends CacheManager with ImageCacheManager {
  // Singleton
  static const key = Constants.appTitle;
  static final CacheProvider _singleton = CacheProvider._();
  factory CacheProvider() => _singleton;
  CacheProvider._() : super(Config(key));

  Future<File?> tryGetFile(String url, {Duration refreshDuration = const Duration(days: 30), String ext = "file"}) async {
    var fileInfo = await getFileFromCache(url);
    if (fileInfo != null) {
      return fileInfo.file;
    } else {
      try {
        var file = await getSingleFile(url);
        await putFile(url, await file.readAsBytes(), key: url, maxAge: refreshDuration, fileExtension: ext);
        return file;
      } catch (e) {
        // TODO
        return null;
      }
    }
  }
}
