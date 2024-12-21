/*
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();

  factory CacheService() {
    return _instance;
  }

  CacheService._internal();

  final BaseCacheManager _cacheManager = DefaultCacheManager();

  // Initialize the cache service (useful if you need any additional setup)
  Future<void> initialize() async {
    // You can perform additional setup here if needed.
    // DefaultCacheManager is already configured with sensible defaults.
  }

  // Store data (using CacheManager, it will handle caching)
  Future<void> store(String key, dynamic data, {String type = 'text'}) async {
    if (type == 'text') {
      await _cacheManager.putFile(key, data is String ? Uint8List.fromList(data.codeUnits) : data);
    } else if (type == 'binary') {
      await _cacheManager.putFile(key, data);
    } else {
      throw UnsupportedError('Unsupported cache data type: $type');
    }
  }

  // Retrieve data from cache
  Future<dynamic> retrieve(String key) async {
    final fileInfo = await _cacheManager.getFileFromCache(key);
    if (fileInfo != null) {
      return String.fromCharCodes(await fileInfo.file.readAsBytes());
    }
    return null;
  }

  Future<void> remove(String key) async {
    await _cacheManager.removeFile(key);
  }

  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }

  Future<int> getCacheSize() async {
    final cacheDir = await _cacheManager.getFilePath();
    final directory = Directory(cacheDir);
    final files = directory.listSync(recursive: true);
    int totalSize = 0;

    for (final file in files) {
      if (file is File) {
        totalSize += await file.length();
      }
    }
    return totalSize;
  }
}
*/