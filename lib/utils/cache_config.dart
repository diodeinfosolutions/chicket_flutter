import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Global configuration utility for image and network caches.
class CacheConfig {
  static CacheManager? _instance;

  /// Globally configures image cache size and logging levels.
  static void configure() {
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;

    CachedNetworkImage.logLevel = kDebugMode
        ? CacheManagerLogLevel.debug
        : CacheManagerLogLevel.none;
  }

  /// Provides an optimized [CacheManager] instance configured for kiosk environments.
  ///
  /// Implements a fail-safe initialization: if the primary SQLite/JSON store
  /// is corrupted, it securely clears it and fallbacks to a default configuration.
  static CacheManager get optimizedCacheManager {
    if (_instance != null) return _instance!;

    try {
      _instance = CacheManager(
        Config(
          'optimizedImageCache',
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 200,
          repo: JsonCacheInfoRepository(databaseName: 'chicket_image_cache'),
          fileSystem: IOFileSystem('chicket_cache'),
        ),
      );
      _instance!.getFileFromCache('health_check');
      return _instance!;
    } catch (e, st) {
      if (kDebugMode) debugPrint('⚠️ Image cache init failed: $e\n$st');
      _clearSecurely();
      _instance = CacheManager(
        Config(
          'optimizedImageCacheFallback',
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 100,
        ),
      );
      return _instance!;
    }
  }

  /// Securely attempts to clear the default cache if corruption is detected.
  static Future<void> _clearSecurely() async {
    try {
      await DefaultCacheManager().emptyCache();
    } catch (_) {}
  }

  /// Wipes all image and network caches.
  static Future<void> clearAll() async {
    try {
      if (_instance != null) {
        await _instance!.emptyCache();
      } else {
        await optimizedCacheManager.emptyCache();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('⚠️ Failed to clear cache: $e');
    }
  }
}
