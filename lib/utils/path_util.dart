import 'dart:core';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PathUtil {

  static Future<String> getStoragePath() async {
    if (Platform.isAndroid){
     return (await getExternalStorageDirectory())!.path;
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
  }

  ///内部存储路径
  static Future<String> dataPath() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  ///缓存目录
  static Future<String> cacheFilePath() async {
    return (await getTemporaryDirectory()).path;
  }

  static Future<String> downloadPath() async {
    String value = p.join(await PathUtil.getStoragePath(), 'download');
    if (!Directory(value).existsSync()) {
      Directory(value).createSync(recursive: true);
    }
    return value;
  }

  static Future<String> downloadImagePath() async {
    String value = p.join(await PathUtil.getStoragePath(), 'images');
    if (!Directory(value).existsSync()) {
      Directory(value).createSync(recursive: true);
    }
    return value;
  }


}
