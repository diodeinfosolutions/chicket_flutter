import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chicket/api/models/menu_models.dart';

class MenuCacheService extends GetxService {
  static const String _boxName = 'menu_cache';
  static const String _menuKey = 'cached_menu';
  static const String _lastFetchKey = 'last_fetch_time';
  static const String _menuHashKey = 'menu_hash';
  
  static const Duration _refreshInterval = Duration(minutes: 15);
  
  late Box _box;
  
  Future<MenuCacheService> init() async {
    // Don't call Hive.initFlutter() here - it's already called in main.dart
    _box = await Hive.openBox(_boxName);
    debugPrint('MenuCacheService initialized, hasCachedMenu: $hasCachedMenu');
    return this;
  }

  bool get hasCachedMenu {
    final hasKey = _box.containsKey(_menuKey);
    debugPrint('hasCachedMenu check: $hasKey');
    return hasKey;
  }

  bool get shouldRefresh {
    final lastFetch = _box.get(_lastFetchKey) as int?;
    if (lastFetch == null) {
      debugPrint('shouldRefresh: true (no last fetch time)');
      return true;
    }
    
    final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetch);
    final diff = DateTime.now().difference(lastFetchTime);
    final shouldRefreshResult = diff > _refreshInterval;
    debugPrint('shouldRefresh: $shouldRefreshResult (last fetch: ${diff.inMinutes} min ago)');
    return shouldRefreshResult;
  }

  MenuResponse? getCachedMenu() {
    try {
      final jsonString = _box.get(_menuKey) as String?;
      if (jsonString == null) {
        debugPrint('getCachedMenu: no cached data');
        return null;
      }
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final menu = MenuResponse.fromJson(json);
      debugPrint('getCachedMenu: loaded ${menu.itemCategories?.length ?? 0} categories from cache');
      return menu;
    } catch (e) {
      debugPrint('Error reading cached menu: $e');
      return null;
    }
  }

  Future<void> cacheMenu(MenuResponse menu) async {
    try {
      final jsonString = jsonEncode(menu.toJson());
      final hash = _generateHash(menu);
      
      await _box.put(_menuKey, jsonString);
      await _box.put(_lastFetchKey, DateTime.now().millisecondsSinceEpoch);
      await _box.put(_menuHashKey, hash);
      
      debugPrint('Menu cached successfully (hash: $hash)');
    } catch (e) {
      debugPrint('Error caching menu: $e');
    }
  }

  /// Generate a hash based on menu structure to detect changes
  String _generateHash(MenuResponse menu) {
    final categories = menu.itemCategories ?? [];
    final itemCount = categories.fold<int>(0, (sum, cat) => sum + (cat.items?.length ?? 0));
    final categoryIds = categories.map((c) => c.id).join(',');
    final revision = menu.revision ?? 0;
    
    // Create a hash from revision + category count + item count + category IDs
    return '${revision}_${categories.length}_${itemCount}_${categoryIds.hashCode}';
  }

  bool hasMenuChanged(MenuResponse newMenu) {
    try {
      final newHash = _generateHash(newMenu);
      final oldHash = _box.get(_menuHashKey) as String?;
      
      final changed = oldHash != newHash;
      debugPrint('hasMenuChanged: $changed (old: $oldHash, new: $newHash)');
      return changed;
    } catch (e) {
      debugPrint('Error comparing menu hash: $e');
      return true;
    }
  }

  Future<void> clearCache() async {
    await _box.delete(_menuKey);
    await _box.delete(_lastFetchKey);
    await _box.delete(_menuHashKey);
    debugPrint('Menu cache cleared');
  }

  Future<void> clearAll() async {
    await _box.clear();
    debugPrint('All cache cleared');
  }
}
