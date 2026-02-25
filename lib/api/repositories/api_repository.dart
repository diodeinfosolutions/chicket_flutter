import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:chicket/api/models/banner_models.dart';
import 'package:chicket/api/models/models.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../api_constants.dart';

class ApiRepository {
  final Dio _dio;

  ApiRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'http://192.168.29.121:1001',
              connectTimeout: AppConstants.connectTimeout,
              receiveTimeout: AppConstants.receiveTimeout,
              sendTimeout: AppConstants.sendTimeout,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          ) {
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Future<BannerResponse> getBanner({
    required String organizationId,
    required String terminalGroupId,
  }) async {
    final response = await _dio.post(
      '/api/banners',
      data: {
        'organization_id': organizationId,
        'terminal_group_id': terminalGroupId,
      },
    );
    return BannerResponse.fromJson(response.data);
  }

  Future<ViewMenuResponse> viewMenu({required int menuId}) async {
    final formData = FormData.fromMap({'menuId': menuId});
    final response = await _dio.post('/api/view-menu', data: formData);
    return ViewMenuResponse.fromJson(response.data);
  }

  Future<void> storeOrUpdateMenu() async {
    try {
      await _dio.get('http://192.168.29.121:1001/api/store-or-update-menu');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error calling store-or-update-menu: $e');
      }
    }
  }
}
