import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../api/models/apex_ecr_models.dart';
import '../../api/repositories/apex_ecr_repository.dart';
import '../../constants.dart';
import '../../utils/log_local.dart';

/// Controller for handling Apex ECR (Electronic Cash Register) transactions.
/// Manages SALE, Enquiry, and Settlement operations with the payment terminal.
class ApexEcrController extends GetxController {
  final ApexEcrRepository _repository = Get.find<ApexEcrRepository>();

  /// Indicates if a transaction is currently in progress.
  final RxBool isProcessing = false.obs;

  /// The current status or error message to display to the user.
  final RxString statusMessage = ''.obs;

  /// Initiates a SALE transaction on the EFTPOS terminal.
  ///
  /// [amount] is the transaction value.
  /// [orderId] is used as the invoice or reference number.
  Future<FinancialTxnResponse> processSale(
    double amount,
    String orderId,
  ) async {
    isProcessing.value = true;
    statusMessage.value = 'Initiating payment on EFTPOS...';

    final request = FinancialTxnRequest(
      config: EcrConfig(
        tid: AppConstants.apexEcrTid,
        mid: AppConstants.apexEcrMid,
        merchantSecureKey: AppConstants.apexEcrSecureKey,
        ecrCurrencyCode: AppConstants.apexEcrCurrencyCode,
        ecrTillerUserName: 'Kiosk',
        ecrTillerFullName: 'Chicket Kiosk',
      ),
      printer: EcrPrinter(
        enablePrintPosReceipt: 3,
        invoiceNumber: orderId,
        referenceNumber: 'REF_$orderId',
      ),
      transactionType: 'SALE',
      ecrAmount: amount,
      invoiceNumber: orderId,
    );

    try {
      final response = await _repository.performFinancialTransaction(request);
      logLocal(
        'API: ${AppConstants.apexEcrBaseUrl}EcrComInterface.svc\nRequest: ${request.toXml()}\nResponse: ${response.rawXmlResponse}',
      );

      if ((response.webResponseStatus.toLowerCase() == '0' ||
              response.webResponseStatus.toLowerCase() == 'success') &&
          response.posRespStatus == 1) {
        statusMessage.value = 'Payment Approved!';
      } else {
        statusMessage.value = getErrorMessage(response);
      }

      return response;
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Sale Error: $e');
      logLocal('ApexEcrController processSale error: $e');
      final errorMsg = _getException(e);
      statusMessage.value = errorMsg;
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: errorMsg,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Performs an Enquiry for a previous transaction.
  ///
  /// Used to check the status of a payment if the original response was not received.
  Future<FinancialTxnResponse> processEnquiry({
    required String origInvoiceNumber,
    required String origRrn,
    String? origAuthCode,
  }) async {
    isProcessing.value = true;
    statusMessage.value = 'Initiating Enquiry on EFTPOS...';

    final request = EnquiryRequest(
      config: EcrConfig(
        tid: AppConstants.apexEcrTid,
        mid: AppConstants.apexEcrMid,
        merchantSecureKey: AppConstants.apexEcrSecureKey,
        ecrCurrencyCode: AppConstants.apexEcrCurrencyCode,
        ecrTillerUserName: 'Kiosk',
        ecrTillerFullName: 'Chicket Kiosk',
      ),
      printer: EcrPrinter(enablePrintPosReceipt: 3),
      origInvoiceNumber: origInvoiceNumber,
      origRrn: origRrn,
      origAuthCode: origAuthCode,
    );

    try {
      final response = await _repository.performEnquiry(request);
      logLocal(
        'API: ${AppConstants.apexEcrBaseUrl}/EcrComInterface.svc\nRequest: ${request.toXml()}\nResponse: ${response.rawXmlResponse}',
      );
      if ((response.webResponseStatus.toLowerCase() == '0' ||
              response.webResponseStatus.toLowerCase() == 'success') &&
          response.posRespStatus == 1) {
        statusMessage.value = 'Enquiry Successful!';
      } else {
        statusMessage.value = getErrorMessage(response);
      }
      return response;
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Enquiry Error: $e');
      logLocal('ApexEcrController processEnquiry error: $e');
      final errorMsg = _getException(e);
      statusMessage.value = errorMsg;
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: errorMsg,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Initiates a Settlement (End of Day) process on the EFTPOS terminal.
  Future<FinancialTxnResponse> processSettlement() async {
    isProcessing.value = true;
    statusMessage.value = 'Initiating Settlement on EFTPOS...';

    final request = SettlementRequest(
      config: EcrConfig(
        tid: AppConstants.apexEcrTid,
        mid: AppConstants.apexEcrMid,
        merchantSecureKey: AppConstants.apexEcrSecureKey,
        ecrCurrencyCode: AppConstants.apexEcrCurrencyCode,
        ecrTillerUserName: 'Kiosk',
        ecrTillerFullName: 'Chicket Kiosk',
      ),
    );

    try {
      final response = await _repository.performSettlement(request);
      logLocal(
        'API: ${AppConstants.apexEcrBaseUrl}/EcrComInterface.svc\nRequest: ${request.toXml()}\nResponse: ${response.rawXmlResponse}',
      );
      if (response.webResponseStatus.toLowerCase() == '0' ||
          response.webResponseStatus.toLowerCase() == 'success') {
        statusMessage.value = 'Settlement Successful!';
      } else {
        statusMessage.value = getErrorMessage(response);
      }
      return response;
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Settlement Error: $e');
      logLocal('ApexEcrController processSettlement error: $e');
      final errorMsg = _getException(e);
      statusMessage.value = errorMsg;
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: errorMsg,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Maps technical ECR response codes to user-friendly translatable strings.
  String getErrorMessage(FinancialTxnResponse response) {
    if (response.webResponseStatus.toLowerCase() != '0' &&
        response.webResponseStatus.toLowerCase() != 'success') {
      if (response.webResponseErrorDesc?.contains('Timeout') == true) {
        return 'timeout_error'.tr;
      }
      if (response.webResponseErrorDesc?.contains('Network') == true) {
        return 'network_error'.tr;
      }
      if (response.webResponseErrorDesc != null &&
          response.webResponseErrorDesc!.isNotEmpty) {
        return response.webResponseErrorDesc!;
      }
    }

    if (response.posRespStatus == 0) {
      return response.posRespText?.isNotEmpty == true
          ? response.posRespText!
          : 'declined_error'.tr;
    }

    return response.posRespText ?? 'payment_failed'.tr;
  }

  /// Extracts friendly error messages from various exception types.
  String _getException(Object e) {
    if (e is Exception && e.toString().contains('DioException')) {
      final str = e.toString().toLowerCase();
      if (str.contains('timeout')) return 'timeout_error'.tr;
      if (str.contains('connection')) return 'network_error'.tr;
      return 'server_error'.tr;
    }
    return 'unknown_error'.tr;
  }

  /// Resets the controller state.
  void reset() {
    isProcessing.value = false;
    statusMessage.value = '';
  }
}
