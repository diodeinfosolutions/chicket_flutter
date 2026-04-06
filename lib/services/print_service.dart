import 'dart:ui' as ui;
import 'package:chicket/gen/assets.gen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icod_printer/icod_printer.dart';
import 'package:icod_printer/printer_builder.dart';
import 'package:chicket/api/models/delivery_models.dart';
import 'package:chicket/services/kiosk_config_service.dart';
import 'package:chicket/utils/log_local.dart';

class PrintService extends GetxService {
  final KioskConfigService _configService = Get.find<KioskConfigService>();

  Future<void> printReceipt(
    OrderInfo orderInfo, {
    List<Map<String, dynamic>>? fallbackCart,
    double? fallbackTotal,
  }) async {
    final order = orderInfo.order;
    final config = _configService.config.value?.printerConfig;

    if (config == null) {
      logLocal('Print Error: No printer configured.');
      return;
    }

    // Determine if we need to use the local cart data because API response is incomplete
    final bool useFallback =
        order == null || order.items == null || order.items!.isEmpty;
    if (useFallback && fallbackCart == null) {
      logLocal(
        'Print Error: Order details missing from API AND no fallback cart provided.',
      );
      return;
    }

    try {
      if (useFallback) {
        logLocal(
          'Print Warning: API order details missing. Using local cart fallback for ${orderInfo.id}.',
        );
      }

      await Printer.connect(config);

      // Load Logo
      final ByteData logoData = await rootBundle.load(Assets.png.logo.path);
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      final Uint8List? printerLogo = await Printer.decodeImage(
        logoBytes,
        width: 300,
      );

      final builder = EscPosBuilder();
      builder.setLineSpacing(38);

      // Header
      builder.setAlignment(EscPosBuilder.alignCenter);
      if (printerLogo != null) {
        builder.image(printerLogo);
      }
      builder.line("CHICKET", size: EscPosBuilder.sizeNormal, bold: true);
      builder.line("JANABIYA BRANCH");
      builder.line("CR NO: 122703-1");
      builder.line("BLOCK 571 - ROAD 7144");
      builder.line("BUILDING 1430 - SHOP 16");
      builder.line("VAT TRN: 220004557300002");
      builder.divider();

      await _addLine(builder, "TAX INVOICE", bold: true, alignment: EscPosBuilder.alignCenter);
      await _addLine(builder, "فاتورة ضريبية مبسطة", bold: true, alignment: EscPosBuilder.alignCenter);
      builder.setAlignment(EscPosBuilder.alignLeft);

      final openTime = order?.whenCreated ?? DateTime.now().toString();

      // Invoice Number Logic: Priority: 1. externalNumber, 2. order.number, 3. last 4 of posId
      String invoiceNo = '-';
      if (orderInfo.externalNumber != null &&
          orderInfo.externalNumber!.isNotEmpty) {
        invoiceNo = orderInfo.externalNumber!;
      } else if (order?.number != null) {
        invoiceNo = order!.number.toString();
      } else if (orderInfo.posId != null) {
        final pid = orderInfo.posId!;
        invoiceNo = pid.length >= 4
            ? pid.substring(pid.length - 4).toUpperCase()
            : pid.toUpperCase();
      }

      await _addLine(builder, "Date: ${formatDate(openTime)}");
      await _addLine(builder, "التاريخ: ${formatDate(openTime)}");
      await _addLine(builder, "Inv No: $invoiceNo");
      await _addLine(builder, "رقم الفاتورة: $invoiceNo");
      builder.divider();

      // Table Header
      await _addRow(builder, "Name", "Qty", "Amount", bold: true);
      await _addRow(builder, "الاسم", "الكمية", "المبلغ", bold: true);
      builder.divider();

      // Ensure normal size for items
      builder.setTextSize(EscPosBuilder.sizeNormal);
      builder.setBold(false);

      // Items
      if (!useFallback) {
        // Print from API response (OrderItemResponse)
        final items = order.items ?? [];
        for (final item in items) {
          final enName = item.product?.name ?? "-";
          final arName = item.product?.nameAr;

          final qty = item.amount?.toString() ?? "1";
          final price = (item.price ?? 0).toStringAsFixed(3);
          
          await _addRow(builder, enName, qty, price);
          if (arName != null && arName.trim().isNotEmpty) {
            await _addLine(builder, arName);
          }

          if (item.modifiers != null && item.modifiers!.isNotEmpty) {
            for (final mod in item.modifiers!) {
              final modEnName = mod.product?.name ?? "";
              final modArName = mod.product?.nameAr;

              if (modEnName.isNotEmpty) {
                await _addLine(builder, "  $modEnName");
              }
              if (modArName != null && modArName.trim().isNotEmpty) {
                await _addLine(builder, "  $modArName");
              }
            }
          }
        }
      } else {
        // Print from cart fallback (Map<String, dynamic>)
        for (final item in fallbackCart!) {
          final enName = item['name'] as String? ?? "Item";
          final arName = item['nameAr'] as String?;

          final qty = item['qty']?.toString() ?? "1";
          final price = (item['price'] as num? ?? 0).toStringAsFixed(3);
          
          await _addRow(builder, enName, qty, price);
          if (arName != null && arName.trim().isNotEmpty) {
            await _addLine(builder, arName);
          }

          final modifiers =
              item['modifiers'] as Map<String, List<Map<String, dynamic>>>?;
          if (modifiers != null) {
            for (final group in modifiers.values) {
              for (final mod in group) {
                final modEnName = mod['name'] as String? ?? "";
                final modArName = mod['nameAr'] as String?;

                if (modEnName.isNotEmpty) {
                  await _addLine(builder, "  $modEnName");
                }
                if (modArName != null && modArName.trim().isNotEmpty) {
                  await _addLine(builder, "  $modArName");
                }
              }
            }
          }
        }
      }

      builder.divider();

      // Summary
      final totalSum = order?.sum?.toDouble() ?? fallbackTotal ?? 0.0;
      final totalBeforeVat = totalSum / 1.1;
      final vatAmount = totalSum - totalBeforeVat;

      builder.setAlignment(EscPosBuilder.alignRight);
      await _addLine(builder, "Total Excluding VAT: ${totalBeforeVat.toStringAsFixed(3)}", alignment: EscPosBuilder.alignRight);
      await _addLine(builder, "الإجمالي غير شامل الضريبة: ${totalBeforeVat.toStringAsFixed(3)}", alignment: EscPosBuilder.alignRight);
      await _addLine(builder, "VAT (10%): ${vatAmount.toStringAsFixed(3)}", alignment: EscPosBuilder.alignRight);
      await _addLine(builder, "ضريبة القيمة المضافة (١٠٪): ${vatAmount.toStringAsFixed(3)}", alignment: EscPosBuilder.alignRight);

      await _addLine(builder, "TOTAL DUE: ${totalSum.toStringAsFixed(3)}", bold: true, alignment: EscPosBuilder.alignRight);
      await _addLine(builder, "المبلغ الإجمالي: ${totalSum.toStringAsFixed(3)}", bold: true, alignment: EscPosBuilder.alignRight);
      builder.divider();

      // Payment
      String paymentName = "Cash";
      String? paymentNameAr = "نقداً";

      if (!useFallback) {
        if (order.payments != null && order.payments!.isNotEmpty) {
          final pType = order.payments!.first.paymentType;
          paymentName = pType?.name ?? "Cash";
          paymentNameAr = pType?.nameAr;
        }
      }

      await _addRow(builder, paymentName, "", totalSum.toStringAsFixed(3));
      if (paymentNameAr != null && paymentNameAr.trim().isNotEmpty) {
        await _addLine(builder, paymentNameAr, alignment: EscPosBuilder.alignRight);
      }

      builder.setAlignment(EscPosBuilder.alignCenter);
      await _addLine(builder, "ALL AMOUNTS IN BAHRAINI DINAR", alignment: EscPosBuilder.alignCenter);
      await _addLine(builder, "جميع المبالغ بالدينار البحريني", alignment: EscPosBuilder.alignCenter);
      builder.divider();

      await _addLine(builder, "THANK YOU! SEE YOU SOON!", bold: true, alignment: EscPosBuilder.alignCenter);
      await _addLine(builder, "شكراً لزيارتكم! نراكم قريباً", bold: true, alignment: EscPosBuilder.alignCenter);

      builder.feed(1);
      builder.cut();

      await Printer.printBytes(config, builder.build());
      logLocal('Receipt printed successfully for order $invoiceNo');
    } catch (e) {
      logLocal('Print Error: $e');
      if (kDebugMode) print('Print Error: $e');
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return "-";
    try {
      final dt = DateTime.parse(dateStr);
      return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return dateStr;
    }
  }
 
  bool _hasArabic(String text) {
    return text.contains(RegExp(r'[\u0600-\u06FF]'));
  }
 
  Future<void> _addLine(
    EscPosBuilder builder,
    String text, {
    bool bold = false,
    int size = EscPosBuilder.sizeNormal,
    int alignment = EscPosBuilder.alignLeft,
  }) async {
    if (_hasArabic(text)) {
      final imageBytes = await _renderTextToImage(
        text,
        bold: bold,
        fontSize: size == EscPosBuilder.sizeNormal ? 24 : 32,
        alignment: alignment,
      );
      final printerImage = await Printer.decodeImage(imageBytes, width: 380);
      if (printerImage != null) {
        builder.setAlignment(alignment);
        builder.image(printerImage);
      }
    } else {
      builder.setAlignment(alignment);
      builder.setTextSize(size);
      builder.setBold(bold);
      builder.line(text);
    }
  }
 
  Future<void> _addRow(
    EscPosBuilder builder,
    String col1,
    String col2,
    String col3, {
    bool bold = false,
  }) async {
    if (_hasArabic(col1) || _hasArabic(col2) || _hasArabic(col3)) {
      final imageBytes = await _renderRowToImage(col1, col2, col3, bold: bold);
      final printerImage = await Printer.decodeImage(imageBytes, width: 380);
      if (printerImage != null) {
        builder.setAlignment(EscPosBuilder.alignCenter);
        builder.image(printerImage);
      }
    } else {
      builder.setBold(bold);
      builder.row(col1, col2, col3);
    }
  }
 
  Future<Uint8List> _renderTextToImage(
    String text, {
    bool bold = false,
    double fontSize = 24,
    int alignment = EscPosBuilder.alignLeft,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    const double width = 380.0;
 
    final textAlign = alignment == EscPosBuilder.alignCenter
        ? ui.TextAlign.center
        : (alignment == EscPosBuilder.alignRight
            ? ui.TextAlign.right
            : ui.TextAlign.left);
 
    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: textAlign,
      fontSize: fontSize,
      fontWeight: bold ? ui.FontWeight.bold : ui.FontWeight.normal,
      fontFamily: 'Cairo',
    ))
      ..pushStyle(ui.TextStyle(color: const ui.Color(0xFF000000)))
      ..addText(text);
 
    final paragraph = paragraphBuilder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: width));
 
    canvas.drawParagraph(paragraph, const ui.Offset(0, 0));
 
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      width.toInt(),
      paragraph.height.toInt().clamp(1, 1000),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
 
  Future<Uint8List> _renderRowToImage(
    String col1,
    String col2,
    String col3, {
    bool bold = false,
    double fontSize = 24,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    const double width = 380.0;
 
    // Draw 3 columns
    void drawCol(String text, double x, double colWidth, ui.TextAlign align) {
      final pb = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: align,
        fontSize: fontSize,
        fontWeight: bold ? ui.FontWeight.bold : ui.FontWeight.normal,
        fontFamily: 'Cairo',
      ))
        ..pushStyle(ui.TextStyle(color: const ui.Color(0xFF000000)))
        ..addText(text);
      final p = pb.build();
      p.layout(ui.ParagraphConstraints(width: colWidth));
      canvas.drawParagraph(p, ui.Offset(x, 0));
    }
 
    drawCol(col1, 0, width * 0.6, ui.TextAlign.left);
    drawCol(col2, width * 0.6, width * 0.15, ui.TextAlign.center);
    drawCol(col3, width * 0.75, width * 0.25, ui.TextAlign.right);
 
    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), (fontSize * 1.5).toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
