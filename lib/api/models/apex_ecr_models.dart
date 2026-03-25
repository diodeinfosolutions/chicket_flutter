import 'package:xml/xml.dart';

class EcrConfig {
  final String tid;
  final String mid;
  final String merchantSecureKey;
  final String ecrCurrencyCode;
  final String? ecrTillerUserName;
  final String? ecrTillerFullName;

  EcrConfig({
    required this.tid,
    required this.mid,
    required this.merchantSecureKey,
    required this.ecrCurrencyCode,
    this.ecrTillerUserName,
    this.ecrTillerFullName,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'ns:Config',
      nest: () {
        // WCF DataContractSerializer requires alphabetical order
        builder.element('ns:EcrCurrencyCode', nest: ecrCurrencyCode);
        if (ecrTillerFullName != null) {
          builder.element('ns:EcrTillerFullName', nest: ecrTillerFullName);
        }
        if (ecrTillerUserName != null) {
          builder.element('ns:EcrTillerUserName', nest: ecrTillerUserName);
        }
        builder.element('ns:MerchantSecureKey', nest: merchantSecureKey);
        builder.element('ns:Mid', nest: mid);
        builder.element('ns:Tid', nest: tid);
      },
    );
  }
}

class EcrPrinter {
  final int printerWidth;
  final int enablePrintPosReceipt;
  final int enablePrintReceiptNote;
  final String? receiptNote;
  final String? invoiceNumber;
  final String? referenceNumber;

  EcrPrinter({
    this.printerWidth = 40,
    this.enablePrintPosReceipt = 3,
    this.enablePrintReceiptNote = 0,
    this.receiptNote,
    this.invoiceNumber,
    this.referenceNumber,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'ns:Printer',
      nest: () {
        // WCF DataContractSerializer requires alphabetical order
        builder.element(
          'ns:EnablePrintPosReceipt',
          nest: enablePrintPosReceipt.toString(),
        );
        builder.element(
          'ns:EnablePrintReceiptNote',
          nest: enablePrintReceiptNote.toString(),
        );
        if (invoiceNumber != null) {
          builder.element('ns:InvoiceNumber', nest: invoiceNumber);
        }
        builder.element('ns:PrinterWidth', nest: printerWidth.toString());
        if (receiptNote != null) {
          builder.element('ns:ReceiptNote', nest: receiptNote);
        }
        if (referenceNumber != null) {
          builder.element('ns:ReferenceNumber', nest: referenceNumber);
        }
      },
    );
  }
}

class FinancialTxnRequest {
  final EcrConfig config;
  final EcrPrinter printer;
  final String transactionType; // SALE, REFUND, PREAUTH, COMPLETION, VOID
  final double? ecrAmount;
  final String? invoiceNumber;
  final String? authCode;
  final String? panEncrypted;

  FinancialTxnRequest({
    required this.config,
    required this.printer,
    required this.transactionType,
    this.ecrAmount,
    this.invoiceNumber,
    this.authCode,
    this.panEncrypted,
  });

  String toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element(
      'soapenv:Envelope',
      namespaces: {
        'http://schemas.xmlsoap.org/soap/envelope/': 'soapenv',
        'http://tempuri.org/': 'tem',
        'http://schemas.datacontract.org/2004/07/': 'ns',
      },
      nest: () {
        builder.element('soapenv:Header');
        builder.element(
          'soapenv:Body',
          nest: () {
            final type = transactionType.toUpperCase();
            final actionName =
                (type == 'VOID' || type == 'VOIDBYINVOICE')
                    ? 'tem:Void'
                    : 'tem:Sale';

            builder.element(
              actionName,
              nest: () {
                builder.element(
                  'tem:webReq',
                  nest: () {
                    config.buildXml(builder);
                    if (ecrAmount != null) {
                      builder.element(
                        'ns:EcrAmount',
                        nest: ecrAmount!.toStringAsFixed(3),
                      );
                    }
                    printer.buildXml(builder);
                  },
                );
              },
            );
          },
        );
      },
    );
    return builder.buildDocument().toXmlString();
  }
}

class FinancialTxnResponse {
  final String webResponseStatus;
  final String? webResponseErrorDesc;
  final double? posAmount;
  final String? posCurrencyCode;
  final String? posRRN;
  final String? posAuthCode;
  final String? posRespCode;
  final String? posRespText;
  final int? posRespStatus; // -1: Unknown, 0: Declined, 1: Approved
  final String? posInvoiceNumber;
  final int? posCVMId;
  final String? posTxnName;
  final String? posBatchNumber;
  final String? posStan;
  final String? posDate;
  final String? posTime;
  final String? posReceipt;
  final String? rawXmlResponse;

  FinancialTxnResponse({
    required this.webResponseStatus,
    this.webResponseErrorDesc,
    this.posAmount,
    this.posCurrencyCode,
    this.posRRN,
    this.posAuthCode,
    this.posRespCode,
    this.posRespText,
    this.posRespStatus,
    this.posInvoiceNumber,
    this.posCVMId,
    this.posTxnName,
    this.posBatchNumber,
    this.posStan,
    this.posDate,
    this.posTime,
    this.posReceipt,
    this.rawXmlResponse,
  });

  factory FinancialTxnResponse.fromXml(
    String xmlString, {
    String rootNodeName = 'FinancialTxnResponse',
  }) {
    try {
      final document = XmlDocument.parse(xmlString);
      final responseNode = document.descendants
          .whereType<XmlElement>()
          .where((e) => e.name.local == rootNodeName)
          .firstOrNull;
      if (responseNode == null) {
        return FinancialTxnResponse(
          webResponseStatus: '99',
          webResponseErrorDesc: 'Invalid XML: No $rootNodeName node found.',
          rawXmlResponse: xmlString,
        );
      }

      String? elementText(String name) {
        return responseNode.descendants
            .whereType<XmlElement>()
            .where((e) => e.name.local == name)
            .firstOrNull
            ?.innerText;
      }

      // DE wrapper or direct Result wrappers
      final resultNodeName = rootNodeName.replaceAll('Response', 'Result');

      final deNode = responseNode.descendants
          .whereType<XmlElement>()
          .where(
            (e) =>
                e.name.local == '${rootNodeName}DE' ||
                e.name.local == resultNodeName,
          )
          .firstOrNull;

      String? deElementText(String name) {
        if (deNode != null) {
          final val = deNode.descendants
              .whereType<XmlElement>()
              .where((e) => e.name.local == name)
              .firstOrNull
              ?.innerText;
          if (val != null) return val;
        }
        return document.descendants
            .whereType<XmlElement>()
            .where((e) => e.name.local == name)
            .firstOrNull
            ?.innerText;
      }

      return FinancialTxnResponse(
        webResponseStatus: elementText('WebResponseStatus') ?? '99',
        webResponseErrorDesc: elementText('WebResponseErrorDesc'),
        posAmount: double.tryParse(deElementText('PosAmount') ?? ''),
        posCurrencyCode: deElementText('PosCurrencyCode'),
        posRRN: deElementText('PosRRN'),
        posAuthCode: deElementText('PosAuthCode'),
        posRespCode: deElementText('PosRespCode'),
        posRespText: deElementText('PosRespText'),
        posRespStatus: int.tryParse(deElementText('PosRespStatus') ?? ''),
        posInvoiceNumber: deElementText('PosInvoiceNumber'),
        posCVMId: int.tryParse(deElementText('PosCVMId') ?? ''),
        posTxnName: deElementText('PosTxnName'),
        posBatchNumber: deElementText('PosBatchNumber'),
        posStan: deElementText('PosStan'),
        posDate: deElementText('PosDate'),
        posTime: deElementText('PosTime'),
        posReceipt: deElementText('PosReceipt'),
        rawXmlResponse: xmlString,
      );
    } catch (e) {
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: 'Failed to parse XML: $e',
        rawXmlResponse: xmlString,
      );
    }
  }
}

class EnquiryRequest {
  final EcrConfig config;
  final EcrPrinter printer;
  final String? origAuthCode;
  final String origInvoiceNumber;
  final String origRrn;

  EnquiryRequest({
    required this.config,
    required this.printer,
    this.origAuthCode,
    required this.origInvoiceNumber,
    required this.origRrn,
  });

  String toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element(
      'soapenv:Envelope',
      namespaces: {
        'http://schemas.xmlsoap.org/soap/envelope/': 'soapenv',
        'http://tempuri.org/': 'tem',
        'http://schemas.datacontract.org/2004/07/': 'ns',
      },
      nest: () {
        builder.element('soapenv:Header');
        builder.element(
          'soapenv:Body',
          nest: () {
            builder.element(
              'tem:Enquiry',
              nest: () {
                builder.element(
                  'tem:webReq',
                  nest: () {
                    // EnquiryRequest sequence: Config, OrigAuthCode, OrigInvoiceNumber, OrigRrn, Printer
                    config.buildXml(builder);
                    if (origAuthCode != null) {
                      builder.element('ns:OrigAuthCode', nest: origAuthCode);
                    }
                    builder.element(
                      'ns:OrigInvoiceNumber',
                      nest: origInvoiceNumber,
                    );
                    builder.element('ns:OrigRrn', nest: origRrn);
                    printer.buildXml(builder);
                  },
                );
              },
            );
          },
        );
      },
    );
    return builder.buildDocument().toXmlString();
  }
}

class SettlementRequest {
  final EcrConfig config;

  SettlementRequest({required this.config});

  String toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element(
      'soapenv:Envelope',
      namespaces: {
        'http://schemas.xmlsoap.org/soap/envelope/': 'soapenv',
        'http://tempuri.org/': 'tem',
        'http://schemas.datacontract.org/2004/07/': 'ns',
      },
      nest: () {
        builder.element('soapenv:Header');
        builder.element(
          'soapenv:Body',
          nest: () {
            builder.element(
              'tem:Settlement',
              nest: () {
                builder.element(
                  'tem:webReq',
                  nest: () {
                    config.buildXml(builder);
                  },
                );
              },
            );
          },
        );
      },
    );
    return builder.buildDocument().toXmlString();
  }
}
