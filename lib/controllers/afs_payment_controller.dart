import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:afs_payment/afs_payment.dart';
import '../../constants.dart';
import '../../utils/log_local.dart';

/// Controller for handling AFS (Apex ECR) transactions.
/// Manages SALE, Enquiry, and Settlement operations with the payment terminal.
class AfsPaymentController extends GetxController {

  /// Indicates if a transaction is currently in progress.
  final RxBool isProcessing = false.obs;

  /// The current status or error message to display to the user.
  final RxString statusMessage = ''.obs;

  /// Initiates a SALE transaction on the EFTPOS terminal.
  ///
  /// [amount] is the transaction value.
  /// [orderId] is used as the invoice or reference number.
  Future<AfsFinancialTxnResponse> processSale(
    double amount,
    String orderId,
  ) async {
    isProcessing.value = true;
    statusMessage.value = 'Initiating payment on EFTPOS...';

    try {
      final response = await AfsPayment.instance.processSale(
        amount: amount,
        orderId: orderId,
        tillerUserName: 'Kiosk',
        tillerFullName: '${AppConstants.appName} Kiosk',
      );

      logLocal(
        'Request: Sale for $orderId\nResponse: ${response.rawXmlResponse}',
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
      if (kDebugMode) debugPrint('AfsPayment Sale Error: $e');
      logLocal('AfsPaymentController processSale error: $e');
      final errorMsg = _getException(e);
      statusMessage.value = errorMsg;
      return AfsFinancialTxnResponse(
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
  Future<AfsFinancialTxnResponse> processEnquiry({
    required String origInvoiceNumber,
    required String origRrn,
    String? origAuthCode,
  }) async {
    isProcessing.value = true;
    statusMessage.value = 'Initiating Enquiry on EFTPOS...';

    try {
      final response = await AfsPayment.instance.processEnquiry(
        origInvoiceNumber: origInvoiceNumber,
        origRrn: origRrn,
        origAuthCode: origAuthCode,
      );

      logLocal(
        'Request: Enquiry for $origInvoiceNumber\nResponse: ${response.rawXmlResponse}',
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
      if (kDebugMode) debugPrint('AfsPayment Enquiry Error: $e');
      logLocal('AfsPaymentController processEnquiry error: $e');
      final errorMsg = _getException(e);
      statusMessage.value = errorMsg;
      return AfsFinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: errorMsg,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Initiates a Settlement (End of Day) process on the EFTPOS terminal.
  Future<AfsFinancialTxnResponse> processSettlement() async {
    isProcessing.value = true;
    statusMessage.value = 'Initiating Settlement on EFTPOS...';

    try {
      final response = await AfsPayment.instance.processSettlement();

      logLocal(
        'Request: Settlement\nResponse: ${response.rawXmlResponse}',
      );

      if (response.webResponseStatus.toLowerCase() == '0' ||
          response.webResponseStatus.toLowerCase() == 'success') {
        statusMessage.value = 'Settlement Successful!';
      } else {
        statusMessage.value = getErrorMessage(response);
      }
      return response;
    } catch (e) {
      if (kDebugMode) debugPrint('AfsPayment Settlement Error: $e');
      logLocal('AfsPaymentController processSettlement error: $e');
      final errorMsg = _getException(e);
      statusMessage.value = errorMsg;
      return AfsFinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: errorMsg,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Maps technical ECR response codes to user-friendly translatable strings.
  String getErrorMessage(AfsFinancialTxnResponse response) {
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
