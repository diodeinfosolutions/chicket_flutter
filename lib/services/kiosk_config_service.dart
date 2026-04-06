import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icod_printer/icod_printer.dart';
import '../utils/log_local.dart';

/// Model representing the kiosk's configuration and organizational mappings.
class KioskConfig {
  final String organizationId;
  final String organizationName;
  final String terminalGroupId;
  final String terminalGroupName;
  final int externalMenuId;
  final String externalMenuName;
  final String? defaultOrderTypeId;
  final String? defaultOrderTypeName;
  final PrinterConfig? printerConfig;

  KioskConfig({
    required this.organizationId,
    required this.organizationName,
    required this.terminalGroupId,
    required this.terminalGroupName,
    required this.externalMenuId,
    required this.externalMenuName,
    this.defaultOrderTypeId,
    this.defaultOrderTypeName,
    this.printerConfig,
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
    'printerConfig': printerConfig?.toJson(),
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
    printerConfig: json['printerConfig'] != null
        ? PrinterConfig.fromJson(json['printerConfig'] as String)
        : null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KioskConfig &&
          runtimeType == other.runtimeType &&
          organizationId == other.organizationId &&
          terminalGroupId == other.terminalGroupId &&
          externalMenuId == other.externalMenuId &&
          defaultOrderTypeId == other.defaultOrderTypeId &&
          printerConfig?.address == other.printerConfig?.address;

  @override
  int get hashCode =>
      organizationId.hashCode ^
      terminalGroupId.hashCode ^
      externalMenuId.hashCode ^
      defaultOrderTypeId.hashCode ^
      (printerConfig?.address?.hashCode ?? 0);

  @override
  String toString() =>
      'KioskConfig(org: $organizationName, terminal: $terminalGroupName, menu: $externalMenuName)';
}

/// Service that manages the persistence and retrieval of kiosk-specific settings.
class KioskConfigService extends GetxService {
  static const String _configKey = 'kiosk_config';

  SharedPreferences? _prefs;

  /// The observable current kiosk configuration.
  final Rx<KioskConfig?> config = Rx<KioskConfig?>(null);

  /// Returns [true] if the kiosk has been assigned an identity and menu.
  bool get isConfigured => config.value != null;

  /// Returns the current configuration, throwing a [StateError] if not yet loaded.
  KioskConfig get currentConfig {
    if (config.value == null) {
      throw StateError('Kiosk not configured. Call loadConfig() first.');
    }
    return config.value!;
  }

  /// Initializes the service and loads configuration from local storage.
  Future<KioskConfigService> init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadConfig();
    return this;
  }

  /// Loads the configuration from [SharedPreferences].
  Future<void> loadConfig() async {
    try {
      final jsonString = _prefs?.getString(_configKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        config.value = KioskConfig.fromJson(json);
      } else {
        config.value = null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading kiosk config: $e');
      logLocal('loadConfig error: $e');
      config.value = null;
    }
  }

  /// Persists a new [KioskConfig] to local storage.
  Future<bool> saveConfig(KioskConfig newConfig) async {
    try {
      final jsonString = jsonEncode(newConfig.toJson());
      final success = await _prefs?.setString(_configKey, jsonString) ?? false;
      if (success) {
        config.value = newConfig;
      }
      return success;
    } catch (e) {
      if (kDebugMode) debugPrint('Error saving kiosk config: $e');
      logLocal('saveConfig error: $e');
      return false;
    }
  }

  /// Removes the current configuration from local storage.
  Future<bool> clearConfig() async {
    try {
      final success = await _prefs?.remove(_configKey) ?? false;
      if (success) {
        config.value = null;
      }
      return success;
    } catch (e) {
      if (kDebugMode) debugPrint('Error clearing kiosk config: $e');
      logLocal('clearConfig error: $e');
      return false;
    }
  }
}
