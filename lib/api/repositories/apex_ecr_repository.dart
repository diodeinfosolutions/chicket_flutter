import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../api/models/apex_ecr_models.dart';
import '../../constants.dart';
import '../../utils/log_local.dart';

/// Repository for communicating with the Apex ECR (Electronic Cash Register) service.
/// It uses SOAP over HTTP to perform financial transactions on physical payment terminals.
class ApexEcrRepository {
  final Dio _dio;

  ApexEcrRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConstants.apexEcrBaseUrl,
              connectTimeout: const Duration(seconds: 60),
              receiveTimeout: const Duration(seconds: 60),
              sendTimeout: const Duration(seconds: 60),
              headers: {
                'Content-Type': 'text/xml; charset=utf-8',
                'Accept': 'text/xml',
              },
            ),
          ) {
    if (kDebugMode) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final msg = '--> ${options.method} ${options.uri}\nBody: ${options.data}';
            debugPrint(msg);
            logLocal(msg);
            return handler.next(options);
          },
          onResponse: (response, handler) {
            final msg = '<-- ${response.statusCode} ${response.requestOptions.uri}\nResponse: ${response.data}';
            debugPrint(msg);
            logLocal(msg);
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            final msg = '<-- Error ${e.response?.statusCode} ${e.requestOptions.uri}\nError Data: ${e.response?.data}';
            debugPrint(msg);
            logLocal(msg);
            return handler.next(e);
          },
        ),
      );
    }
  }

  /// Executes a financial transaction (Sale or Void) via the ECR terminal.
  Future<FinancialTxnResponse> performFinancialTransaction(
    FinancialTxnRequest request,
  ) async {
    try {
      final xmlData = request.toXml();
      final isVoid = request.transactionType.toUpperCase() == 'VOID';
      final action = isVoid ? 'Void' : 'Sale';

      final response = await _dio.post(
        'EcrComInterface.svc',
        data: xmlData,
        options: Options(
          headers: {
            'SOAPAction': 'http://tempuri.org/IEcrComInterface/$action',
          },
        ),
      );

      return FinancialTxnResponse.fromXml(
        response.data.toString(),
        rootNodeName: '${action}Response',
      );
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Error: $e');
      logLocal('performFinancialTransaction error: $e');
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: 'Network Error: $e',
      );
    }
  }

  /// Queries the status of a previous transaction or the current terminal state.
  Future<FinancialTxnResponse> performEnquiry(EnquiryRequest request) async {
    try {
      final xmlData = request.toXml();

      final response = await _dio.post(
        'EcrComInterface.svc',
        data: xmlData,
        options: Options(
          headers: {
            'SOAPAction': 'http://tempuri.org/IEcrComInterface/Enquiry',
          },
        ),
      );

      return FinancialTxnResponse.fromXml(
        response.data.toString(),
        rootNodeName: 'EnquiryResponse',
      );
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Enquiry Error: $e');
      logLocal('performEnquiry error: $e');
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: 'Network Error: $e',
      );
    }
  }

  /// Triggers a terminal settlement (Daily Close) for the merchant.
  Future<FinancialTxnResponse> performSettlement(
    SettlementRequest request,
  ) async {
    try {
      final xmlData = request.toXml();

      final response = await _dio.post(
        'EcrComInterface.svc',
        data: xmlData,
        options: Options(
          headers: {
            'SOAPAction': 'http://tempuri.org/IEcrComInterface/Settlement',
          },
        ),
      );

      return FinancialTxnResponse.fromXml(
        response.data.toString(),
        rootNodeName: 'SettlementResponse',
      );
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Settlement Error: $e');
      logLocal('performSettlement error: $e');
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: 'Network Error: $e',
      );
    }
  }
}
