import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheConfig {
  static void configure() {
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;

    CachedNetworkImage.logLevel = kDebugMode
        ? CacheManagerLogLevel.debug
        : CacheManagerLogLevel.none;
  }

  static CacheManager get optimizedCacheManager {
    try {
      return CacheManager(
        Config(
          'optimizedImageCache',
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 200,
          repo: JsonCacheInfoRepository(databaseName: 'chicket_image_cache'),
          fileSystem: IOFileSystem('chicket_cache'),
        ),
      );
    } catch (e, st) {
      if (kDebugMode) debugPrint('⚠️ Image cache init failed: $e\n$st');
      clearAll();
      return CacheManager(
        Config(
          'optimizedImageCacheFallback',
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 100,
        ),
      );
    }
  }

  static Future<void> clearAll() async {
    try {
      await optimizedCacheManager.emptyCache();
      if (kDebugMode) debugPrint('🧹 Cleared image cache');
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Failed to clear cache: $e');
    }
  }
}
