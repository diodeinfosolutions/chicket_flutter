import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Appends a log message to a locally stored file.
///
/// - Only active in [kDebugMode].
/// - Filenames include a full timestamp (e.g., kiosk_log_2024-03-14_115658.txt).
/// - Automatically deletes log files older than 7 days.
Future<void> logLocal(String msg) async {
  if (!kDebugMode) return;

  try {
    final now = DateTime.now();
    final dateStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    final fullTimeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}";

    final dir = await getApplicationDocumentsDirectory();
    final logDir = Directory('${dir.path}/logs');

    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    // Run cleanup logic
    await _cleanupOldLogs(logDir, now);

    // Create a unique file for this entry to ensure no overwrites and facilitate TTL
    final file = File('${logDir.path}/kiosk_log_${dateStr}_$timeStr.txt');
    await file.writeAsString('[$fullTimeStr] $msg\n', mode: FileMode.append);
  } catch (e) {
    debugPrint('Failed to log locally: $e');
  }
}

/// Scans the log directory and deletes files with timestamps older than 7 days.
Future<void> _cleanupOldLogs(Directory logDir, DateTime now) async {
  try {
    final List<FileSystemEntity> files = await logDir.list().toList();
    for (var file in files) {
      if (file is File && file.path.contains('kiosk_log_')) {
        final fileName = file.path.split(Platform.pathSeparator).last;
        // Expected format: kiosk_log_YYYY-MM-DD_HHmmss.txt
        final parts = fileName.split('_');
        if (parts.length >= 4) {
          final datePart = parts[2]; // YYYY-MM-DD
          final fileDate = DateTime.tryParse(datePart);

          if (fileDate != null) {
            final difference = now.difference(fileDate).inDays;
            if (difference >= 1) {
              await file.delete();
              debugPrint('Purged old log: $fileName');
            }
          }
        }
      }
    }
  } catch (e) {
    debugPrint('Log cleanup error: $e');
  }
}
