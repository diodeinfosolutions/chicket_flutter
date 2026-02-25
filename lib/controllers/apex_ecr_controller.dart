import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../api/models/apex_ecr_models.dart';
import '../../api/repositories/apex_ecr_repository.dart';
import '../../constants.dart';

class ApexEcrController extends GetxController {
  final ApexEcrRepository _repository = Get.find<ApexEcrRepository>();

  final RxBool isProcessing = false.obs;
  final RxString statusMessage = ''.obs;

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
        enablePrintPosReceipt: 3, // Print both merchant and customer copies
        invoiceNumber: orderId,
        referenceNumber: 'REF_$orderId',
      ),
      transactionType: 'SALE',
      ecrAmount: amount,
    );

    try {
      final response = await _repository.performFinancialTransaction(request);

      if (response.webResponseStatus == '0' && response.posRespStatus == 1) {
        statusMessage.value = 'Payment Approved!';
      } else {
        statusMessage.value =
            'Payment Failed: ${response.posRespText ?? response.webResponseErrorDesc ?? 'Unknown Error'}';
      }

      return response;
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Sale Error: $e');
      statusMessage.value = 'Payment Error: $e';
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: e.toString(),
      );
    } finally {
      isProcessing.value = false;
    }
  }

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
      if (response.webResponseStatus == '0' && response.posRespStatus == 1) {
        statusMessage.value = 'Enquiry Successful!';
      } else {
        statusMessage.value =
            'Enquiry Failed: ${response.posRespText ?? response.webResponseErrorDesc ?? 'Unknown Error'}';
      }
      return response;
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Enquiry Error: $e');
      statusMessage.value = 'Enquiry Error: $e';
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: e.toString(),
      );
    } finally {
      isProcessing.value = false;
    }
  }

  Future<FinancialTxnResponse> processEnquiryByRef({
    required String origReferenceNumber,
    String? origInvoiceNumber,
    String? origRrn,
    String? origAuthCode,
  }) async {
    isProcessing.value = true;
    statusMessage.value = 'Initiating Enquiry By Ref on EFTPOS...';

    final request = EnquiryByRefRequest(
      config: EcrConfig(
        tid: AppConstants.apexEcrTid,
        mid: AppConstants.apexEcrMid,
        merchantSecureKey: AppConstants.apexEcrSecureKey,
        ecrCurrencyCode: AppConstants.apexEcrCurrencyCode,
        ecrTillerUserName: 'Kiosk',
        ecrTillerFullName: 'Chicket Kiosk',
      ),
      printer: EcrPrinter(enablePrintPosReceipt: 3),
      origReferenceNumber: origReferenceNumber,
      origInvoiceNumber: origInvoiceNumber,
      origRrn: origRrn,
      origAuthCode: origAuthCode,
    );

    try {
      final response = await _repository.performEnquiryByRef(request);
      if (response.webResponseStatus == '0' && response.posRespStatus == 1) {
        statusMessage.value = 'Enquiry By Ref Successful!';
      } else {
        statusMessage.value =
            'Enquiry By Ref Failed: ${response.posRespText ?? response.webResponseErrorDesc ?? 'Unknown Error'}';
      }
      return response;
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Enquiry By Ref Error: $e');
      statusMessage.value = 'Enquiry By Ref Error: $e';
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: e.toString(),
      );
    } finally {
      isProcessing.value = false;
    }
  }

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
      if (response.webResponseStatus == '0' && response.posRespStatus == 1) {
        statusMessage.value = 'Settlement Successful!';
      } else {
        statusMessage.value =
            'Settlement Failed: ${response.posRespText ?? response.webResponseErrorDesc ?? 'Unknown Error'}';
      }
      return response;
    } catch (e) {
      if (kDebugMode) debugPrint('ApexECR Settlement Error: $e');
      statusMessage.value = 'Settlement Error: $e';
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: e.toString(),
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void reset() {
    isProcessing.value = false;
    statusMessage.value = '';
  }
}
