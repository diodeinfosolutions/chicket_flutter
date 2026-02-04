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
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    return this;
  }

  bool get hasCachedMenu => _box.containsKey(_menuKey);

  bool get shouldRefresh {
    final lastFetch = _box.get(_lastFetchKey) as int?;
    if (lastFetch == null) return true;
    
    final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetch);
    return DateTime.now().difference(lastFetchTime) > _refreshInterval;
  }

  MenuResponse? getCachedMenu() {
    try {
      final jsonString = _box.get(_menuKey) as String?;
      if (jsonString == null) return null;
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return MenuResponse.fromJson(json);
    } catch (e) {
      debugPrint('Error reading cached menu: $e');
      return null;
    }
  }

  Future<void> cacheMenu(MenuResponse menu) async {
    try {
      final jsonString = jsonEncode(menu.toJson());
      final hash = jsonString.hashCode.toString();
      
      await _box.put(_menuKey, jsonString);
      await _box.put(_lastFetchKey, DateTime.now().millisecondsSinceEpoch);
      await _box.put(_menuHashKey, hash);
      
      debugPrint('Menu cached successfully');
    } catch (e) {
      debugPrint('Error caching menu: $e');
    }
  }

  bool hasMenuChanged(MenuResponse newMenu) {
    try {
      final newJsonString = jsonEncode(newMenu.toJson());
      final newHash = newJsonString.hashCode.toString();
      final oldHash = _box.get(_menuHashKey) as String?;
      
      return oldHash != newHash;
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
