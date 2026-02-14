import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kiosk configuration model
class KioskConfig {
  final String organizationId;
  final String organizationName;
  final String terminalGroupId;
  final String terminalGroupName;
  final int externalMenuId;
  final String externalMenuName;
  final String? defaultOrderTypeId;
  final String? defaultOrderTypeName;

  KioskConfig({
    required this.organizationId,
    required this.organizationName,
    required this.terminalGroupId,
    required this.terminalGroupName,
    required this.externalMenuId,
    required this.externalMenuName,
    this.defaultOrderTypeId,
    this.defaultOrderTypeName,
  });

  Map<String, dynamic> toJson() => {
    'organizationId': organizationId,
    'organizationName': organizationName,
    'terminalGroupId': terminalGroupId,
    'terminalGroupName': terminalGroupName,
    'externalMenuId': externalMenuId,
    'externalMenuName': externalMenuName,
    'defaultOrderTypeId': defaultOrderTypeId,
    'defaultOrderTypeName': defaultOrderTypeName,
  };

  factory KioskConfig.fromJson(Map<String, dynamic> json) => KioskConfig(
    organizationId: json['organizationId'] as String,
    organizationName: json['organizationName'] as String,
    terminalGroupId: json['terminalGroupId'] as String,
    terminalGroupName: json['terminalGroupName'] as String,
    externalMenuId: json['externalMenuId'] as int,
    externalMenuName: json['externalMenuName'] as String,
    defaultOrderTypeId: json['defaultOrderTypeId'] as String?,
    defaultOrderTypeName: json['defaultOrderTypeName'] as String?,
  );

  @override
  String toString() =>
      'KioskConfig(org: $organizationName, terminal: $terminalGroupName, menu: $externalMenuName)';
}

class KioskConfigService extends GetxService {
  static const String _configKey = 'kiosk_config';

  SharedPreferences? _prefs;
  final Rx<KioskConfig?> config = Rx<KioskConfig?>(null);

  bool get isConfigured => config.value != null;

  KioskConfig get currentConfig {
    if (config.value == null) {
      throw StateError('Kiosk not configured. Call loadConfig() first.');
    }
    return config.value!;
  }

  Future<KioskConfigService> init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadConfig();
    return this;
  }

  Future<void> loadConfig() async {
    try {
      final jsonString = _prefs?.getString(_configKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        config.value = KioskConfig.fromJson(json);
        if (kDebugMode) debugPrint('Kiosk config loaded: ${config.value}');
      } else {
        if (kDebugMode) debugPrint('No kiosk config found');
        config.value = null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading kiosk config: $e');
      config.value = null;
    }
  }

  Future<bool> saveConfig(KioskConfig newConfig) async {
    try {
      final jsonString = jsonEncode(newConfig.toJson());
      final success = await _prefs?.setString(_configKey, jsonString) ?? false;
      if (success) {
        config.value = newConfig;
        if (kDebugMode) debugPrint('Kiosk config saved: $newConfig');
      }
      return success;
    } catch (e) {
      if (kDebugMode) debugPrint('Error saving kiosk config: $e');
      return false;
    }
  }

  Future<bool> clearConfig() async {
    try {
      final success = await _prefs?.remove(_configKey) ?? false;
      if (success) {
        config.value = null;
        if (kDebugMode) debugPrint('Kiosk config cleared');
      }
      return success;
    } catch (e) {
      if (kDebugMode) debugPrint('Error clearing kiosk config: $e');
      return false;
    }
  }
}
