import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../api/models/apex_ecr_models.dart';
import '../../constants.dart';

class ApexEcrRepository {
  final Dio _dio;

  ApexEcrRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              // The ECR Service URL. Usually it's strictly configured in the ECR Server.
              // E.g. 'http://192.168.1.100:8000/ApexECRService.svc'
              baseUrl: AppConstants.apexEcrBaseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
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
            if (kDebugMode) debugPrint('--> ${options.method} ${options.uri}');
            if (kDebugMode) debugPrint('Headers: ${options.headers}');
            if (kDebugMode) debugPrint('Body: ${options.data}');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            if (kDebugMode) {
              debugPrint(
                '<-- ${response.statusCode} ${response.requestOptions.uri}',
              );
              debugPrint('Response: ${response.data}');
            }
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            if (kDebugMode) {
              debugPrint(
                '<-- Error ${e.response?.statusCode} ${e.requestOptions.uri}',
              );
              debugPrint('Error Data: ${e.response?.data}');
            }
            return handler.next(e);
          },
        ),
      );
    }
  }

  Future<FinancialTxnResponse> performFinancialTransaction(
    FinancialTxnRequest request,
  ) async {
    try {
      final xmlData = request.toXml();

      final response = await _dio.post(
        '/ApexECRService.svc',
        data: xmlData,
        options: Options(
          headers: {
            'SOAPAction':
                'http://tempuri.org/IEcrComInterface/Sale', // Defaults to Sale for now
          },
        ),
      );

      return FinancialTxnResponse.fromXml(response.data.toString());
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Error: $e');
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: 'Network Error: $e',
      );
    }
  }

  Future<FinancialTxnResponse> performEnquiry(EnquiryRequest request) async {
    try {
      final xmlData = request.toXml();

      final response = await _dio.post(
        '/ApexECRService.svc',
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
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: 'Network Error: $e',
      );
    }
  }

  Future<FinancialTxnResponse> performEnquiryByRef(
    EnquiryByRefRequest request,
  ) async {
    try {
      final xmlData = request.toXml();

      final response = await _dio.post(
        '/ApexECRService.svc',
        data: xmlData,
        options: Options(
          headers: {
            'SOAPAction': 'http://tempuri.org/IEcrComInterface/EnquiryByRef',
          },
        ),
      );

      return FinancialTxnResponse.fromXml(
        response.data.toString(),
        rootNodeName: 'EnquiryByRefResponse',
      );
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR EnquiryByRef Error: $e');
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: 'Network Error: $e',
      );
    }
  }

  Future<FinancialTxnResponse> performSettlement(
    SettlementRequest request,
  ) async {
    try {
      final xmlData = request.toXml();

      final response = await _dio.post(
        '/ApexECRService.svc',
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
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: 'Network Error: $e',
      );
    }
  }
}
