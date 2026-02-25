import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chicket/api/models/view_menu_models.dart';

import '../utils/cache_config.dart';

class MenuCacheService extends GetxService {
  static const String _boxName = 'menu_cache';
  static const String _menuKey = 'cached_menu';
  static const String _lastFetchKey = 'last_fetch_time';
  static const String _menuHashKey = 'menu_hash';

  static const Duration _refreshInterval = Duration(minutes: 15);

  late Box _box;

  Future<MenuCacheService> init() async {
    _box = await Hive.openBox(_boxName);
    if (kDebugMode) {
      debugPrint(
        ' FMenuCacheService initialized, hasCachedMenu: $hasCachedMenu',
      );
    }
    return this;
  }

  bool get hasCachedMenu {
    final hasKey = _box.containsKey(_menuKey);
    if (kDebugMode) debugPrint('hasCachedMenu check: $hasKey');
    return hasKey;
  }

  bool get shouldRefresh {
    final lastFetch = _box.get(_lastFetchKey) as int?;
    if (lastFetch == null) {
      if (kDebugMode) debugPrint('shouldRefresh: true (no last fetch time)');
      return true;
    }

    final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetch);
    final diff = DateTime.now().difference(lastFetchTime);
    final shouldRefreshResult = diff > _refreshInterval;
    if (kDebugMode) {
      debugPrint(
        'shouldRefresh: $shouldRefreshResult (last fetch: ${diff.inMinutes} min ago)',
      );
    }
    return shouldRefreshResult;
  }

  ViewMenuData? getCachedMenu() {
    try {
      final jsonString = _box.get(_menuKey) as String?;
      if (jsonString == null) {
        if (kDebugMode) debugPrint('getCachedMenu: no cached data');
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final menu = ViewMenuData.fromJson(json);
      if (kDebugMode) {
        debugPrint(
          'getCachedMenu: loaded ${menu.itemCategories?.length ?? 0} categories from cache',
        );
      }
      return menu;
    } catch (e) {
      if (kDebugMode) debugPrint('Error reading cached menu: $e');
      return null;
    }
  }

  Future<void> cacheMenu(ViewMenuData menu) async {
    try {
      final jsonString = jsonEncode(menu.toJson());
      final hash = _generateHash(menu);

      await Future.wait([
        _box.put(_menuKey, jsonString),
        _box.put(_lastFetchKey, DateTime.now().millisecondsSinceEpoch),
        _box.put(_menuHashKey, hash),
      ]);

      if (kDebugMode) debugPrint('Menu cached successfully (hash: $hash)');
    } catch (e) {
      if (kDebugMode) debugPrint('Error caching menu: $e');
    }
  }

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

  bool hasMenuChanged(ViewMenuData newMenu) {
    try {
      final newHash = _generateHash(newMenu);
      final oldHash = _box.get(_menuHashKey) as String?;

      final changed = oldHash != newHash;
      if (kDebugMode) {
        debugPrint('hasMenuChanged: $changed (old: $oldHash, new: $newHash)');
      }
      return changed;
    } catch (e) {
      if (kDebugMode) debugPrint('Error comparing menu hash: $e');
      return true;
    }
  }

  Future<void> clearCache() async {
    await Future.wait([
      _box.delete(_menuKey),
      _box.delete(_lastFetchKey),
      _box.delete(_menuHashKey),
      CacheConfig.clearAll(),
    ]);
    if (kDebugMode) debugPrint('Menu cache cleared');
  }

  Future<void> clearAll() async {
    await _box.clear();
    if (kDebugMode) debugPrint('All cache cleared');
  }
}
