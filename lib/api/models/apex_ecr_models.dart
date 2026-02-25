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
      'Config',
      nest: () {
        builder.element('Tid', nest: tid);
        builder.element('Mid', nest: mid);
        builder.element('MerchantSecureKey', nest: merchantSecureKey);
        builder.element('EcrCurrencyCode', nest: ecrCurrencyCode);
        if (ecrTillerUserName != null) {
          builder.element('EcrTillerUserName', nest: ecrTillerUserName);
        }
        if (ecrTillerFullName != null) {
          builder.element('EcrTillerFullName', nest: ecrTillerFullName);
        }
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
      'Printer',
      nest: () {
        builder.element('PrinterWidth', nest: printerWidth.toString());
        builder.element(
          'EnablePrintPosReceipt',
          nest: enablePrintPosReceipt.toString(),
        );
        builder.element(
          'EnablePrintReceiptNote',
          nest: enablePrintReceiptNote.toString(),
        );
        if (receiptNote != null) {
          builder.element('ReceiptNote', nest: receiptNote);
        }
        if (invoiceNumber != null) {
          builder.element('InvoiceNumber', nest: invoiceNumber);
        }
        if (referenceNumber != null) {
          builder.element('ReferenceNumber', nest: referenceNumber);
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

  FinancialTxnRequest({
    required this.config,
    required this.printer,
    required this.transactionType,
    this.ecrAmount,
    this.invoiceNumber,
    this.authCode,
  });

  String toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element(
      'FinancialTxnRequest',
      namespaces: {
        'http://www.w3.org/2001/XMLSchema-instance': 'xsi',
        'http://www.w3.org/2001/XMLSchema': 'xsd',
      },
      nest: () {
        config.buildXml(builder);
        printer.buildXml(builder);
        builder.element('TransactionType', nest: transactionType);
        if (ecrAmount != null) {
          builder.element('EcrAmount', nest: ecrAmount!.toStringAsFixed(3));
        }
        if (invoiceNumber != null) {
          builder.element('InvoiceNumber', nest: invoiceNumber);
        }
        if (authCode != null) {
          builder.element('AuthCode', nest: authCode);
        }
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
        );
      }

      String? elementText(String name) {
        return responseNode.descendants
            .whereType<XmlElement>()
            .where((e) => e.name.local == name)
            .firstOrNull
            ?.innerText;
      }

      // DE wrapper
      final deNodeName = '${rootNodeName}DE';
      final enquiryResultName = 'EnquiryResult';
      final enquiryByRefResultName = 'EnquiryByRefResult';

      final deNode = responseNode.descendants
          .whereType<XmlElement>()
          .where(
            (e) =>
                e.name.local == deNodeName ||
                e.name.local == enquiryResultName ||
                e.name.local == enquiryByRefResultName,
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
      );
    } catch (e) {
      return FinancialTxnResponse(
        webResponseStatus: '99',
        webResponseErrorDesc: 'Failed to parse XML: $e',
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
      'tem:Enquiry',
      namespaces: {
        'http://schemas.xmlsoap.org/soap/envelope/': 'soapenv',
        'http://tempuri.org/': 'tem',
        'http://schemas.datacontract.org/2004/07/': 'ns',
      },
      nest: () {
        builder.element(
          'tem:webReq',
          nest: () {
            builder.element(
              'ns:Config',
              nest: () {
                builder.element('ns:Tid', nest: config.tid);
                builder.element('ns:Mid', nest: config.mid);
                builder.element(
                  'ns:MerchantSecureKey',
                  nest: config.merchantSecureKey,
                );
                builder.element(
                  'ns:EcrCurrencyCode',
                  nest: config.ecrCurrencyCode,
                );
                if (config.ecrTillerUserName != null) {
                  builder.element(
                    'ns:EcrTillerUserName',
                    nest: config.ecrTillerUserName,
                  );
                }
                if (config.ecrTillerFullName != null) {
                  builder.element(
                    'ns:EcrTillerFullName',
                    nest: config.ecrTillerFullName,
                  );
                }
              },
            );
            if (origAuthCode != null) {
              builder.element('ns:OrigAuthCode', nest: origAuthCode);
            }
            builder.element('ns:OrigInvoiceNumber', nest: origInvoiceNumber);
            builder.element('ns:OrigRrn', nest: origRrn);
            builder.element(
              'ns:Printer',
              nest: () {
                builder.element(
                  'ns:PrinterWidth',
                  nest: printer.printerWidth.toString(),
                );
                builder.element(
                  'ns:EnablePrintPosReceipt',
                  nest: printer.enablePrintPosReceipt.toString(),
                );
                builder.element(
                  'ns:EnablePrintReceiptNote',
                  nest: printer.enablePrintReceiptNote.toString(),
                );
                if (printer.receiptNote != null) {
                  builder.element('ns:ReceiptNote', nest: printer.receiptNote);
                }
                if (printer.invoiceNumber != null) {
                  builder.element(
                    'ns:InvoiceNumber',
                    nest: printer.invoiceNumber,
                  );
                }
                if (printer.referenceNumber != null) {
                  builder.element(
                    'ns:ReferenceNumber',
                    nest: printer.referenceNumber,
                  );
                }
              },
            );
          },
        );
      },
    );
    return builder.buildDocument().toXmlString();
  }
}

class EnquiryByRefRequest {
  final EcrConfig config;
  final EcrPrinter printer;
  final String? origAuthCode;
  final String? origInvoiceNumber;
  final String? origRrn;
  final String origReferenceNumber;

  EnquiryByRefRequest({
    required this.config,
    required this.printer,
    this.origAuthCode,
    this.origInvoiceNumber,
    this.origRrn,
    required this.origReferenceNumber,
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
        builder.element(
          'soapenv:Body',
          nest: () {
            builder.element(
              'tem:EnquiryByRef',
              nest: () {
                builder.element(
                  'tem:webReq',
                  nest: () {
                    builder.element(
                      'ns:Config',
                      nest: () {
                        builder.element('ns:Tid', nest: config.tid);
                        builder.element('ns:Mid', nest: config.mid);
                        builder.element(
                          'ns:MerchantSecureKey',
                          nest: config.merchantSecureKey,
                        );
                        builder.element(
                          'ns:EcrCurrencyCode',
                          nest: config.ecrCurrencyCode,
                        );
                        if (config.ecrTillerUserName != null) {
                          builder.element(
                            'ns:EcrTillerUserName',
                            nest: config.ecrTillerUserName,
                          );
                        }
                        if (config.ecrTillerFullName != null) {
                          builder.element(
                            'ns:EcrTillerFullName',
                            nest: config.ecrTillerFullName,
                          );
                        }
                      },
                    );
                    if (origAuthCode != null) {
                      builder.element('ns:OrigAuthCode', nest: origAuthCode);
                    }
                    if (origInvoiceNumber != null) {
                      builder.element(
                        'ns:OrigInvoiceNumber',
                        nest: origInvoiceNumber,
                      );
                    }
                    if (origRrn != null) {
                      builder.element('ns:OrigRrn', nest: origRrn);
                    }
                    builder.element(
                      'ns:Printer',
                      nest: () {
                        builder.element(
                          'ns:PrinterWidth',
                          nest: printer.printerWidth.toString(),
                        );
                        builder.element(
                          'ns:EnablePrintPosReceipt',
                          nest: printer.enablePrintPosReceipt.toString(),
                        );
                        builder.element(
                          'ns:EnablePrintReceiptNote',
                          nest: printer.enablePrintReceiptNote.toString(),
                        );
                        if (printer.receiptNote != null) {
                          builder.element(
                            'ns:ReceiptNote',
                            nest: printer.receiptNote,
                          );
                        }
                        if (printer.invoiceNumber != null) {
                          builder.element(
                            'ns:InvoiceNumber',
                            nest: printer.invoiceNumber,
                          );
                        }
                        builder.element(
                          'ns:ReferenceNumber',
                          nest: origReferenceNumber,
                        );
                      },
                    );
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
      'SettlementRequest',
      namespaces: {
        'http://www.w3.org/2001/XMLSchema-instance': 'xsi',
        'http://www.w3.org/2001/XMLSchema': 'xsd',
      },
      nest: () {
        config.buildXml(builder);
      },
    );
    return builder.buildDocument().toXmlString();
  }
}
