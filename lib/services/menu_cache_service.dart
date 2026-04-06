import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chicket/api/models/view_menu_models.dart';

import '../utils/cache_config.dart';
import '../utils/log_local.dart';

/// Service that manages high-speed menu data caching using Hive.
/// It uses a content hash and revision monitoring to prompt refreshes.
class MenuCacheService extends GetxService {
  static const String _boxName = 'menu_cache';
  static const String _menuKey = 'cached_menu';
  static const String _lastFetchKey = 'last_fetch_time';
  static const String _menuHashKey = 'menu_hash';

  /// How long the local menu cache is considered valid before a background refresh is forced.
  static const Duration _refreshInterval = Duration(minutes: 15);

  late Box _box;

  /// Initializes Hive and opens the menu cache box.
  ///
  /// In case of database corruption (e.g., malformed JSON or disk errors),
  /// it deletes the box and restarts for self-recovery.
  Future<MenuCacheService> init() async {
    try {
      _box = await Hive.openBox(_boxName);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Failed to initialize MenuCacheService: $e');
      }
      logLocal('MenuCacheService init error: $e');
      await Hive.deleteBoxFromDisk(_boxName);
      _box = await Hive.openBox(_boxName);
    }
    return this;
  }

  /// Returns [true] if a menu is currently stored in the cache.
  bool get hasCachedMenu => _box.containsKey(_menuKey);

  /// Returns [true] if the cache has expired based on [_refreshInterval].
  bool get shouldRefresh {
    final lastFetch = _box.get(_lastFetchKey) as int?;
    if (lastFetch == null) return true;

    final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetch);
    final diff = DateTime.now().difference(lastFetchTime);
    return diff > _refreshInterval;
  }

  /// Decodes and returns the [ViewMenuData] from Hive.
  ViewMenuData? getCachedMenu() {
    try {
      final jsonString = _box.get(_menuKey) as String?;
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return ViewMenuData.fromJson(json);
    } catch (e) {
      if (kDebugMode) debugPrint('Error reading cached menu: $e');
      logLocal('getCachedMenu error: $e');
      return null;
    }
  }

  /// Serializes and stores the [MenuProduct] and its fetch metadata into cache.
  Future<void> cacheMenu(ViewMenuData menu) async {
    try {
      final jsonString = jsonEncode(menu.toJson());
      final hash = _generateHash(menu);

      await Future.wait([
        _box.put(_menuKey, jsonString),
        _box.put(_lastFetchKey, DateTime.now().millisecondsSinceEpoch),
        _box.put(_menuHashKey, hash),
      ]);
    } catch (e) {
      if (kDebugMode) debugPrint('Error caching menu: $e');
      logLocal('cacheMenu error: $e');
    }
  }

  /// Generates a unique fingerprint for the menu based on revision, category count, and items.
  String _generateHash(ViewMenuData menu) {
    final categories = menu.itemCategories ?? [];
    final itemCount = categories.fold<int>(
      0,
      (sum, cat) => sum + (cat.items?.length ?? 0),
    );
    final categoryIds = categories.map((c) => c.id).join(',');
    final revision = menu.revision ?? 0;

    return '${revision}_${categories.length}_${itemCount}_${categoryIds.hashCode}';
  }

  /// Compares the hash of a [newMenu] with the cached version to detect changes.
  bool hasMenuChanged(ViewMenuData newMenu) {
    try {
      final newHash = _generateHash(newMenu);
      final oldHash = _box.get(_menuHashKey) as String?;
      return oldHash != newHash;
    } catch (e) {
      if (kDebugMode) debugPrint('Error comparing menu hash: $e');
      logLocal('hasMenuChanged error: $e');
      return true;
    }
  }

  /// Removes the cached menu data but keeps general service settings.
  Future<void> clearCache() async {
    await Future.wait([
      _box.delete(_menuKey),
      _box.delete(_lastFetchKey),
      _box.delete(_menuHashKey),
      CacheConfig.clearAll(),
    ]);
  }

  /// Performs a complete wipe of the Hive box.
  Future<void> clearAll() async {
    await _box.clear();
  }
}
