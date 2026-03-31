import 'dart:ui';
import 'package:get/get.dart';

/// Manages localized application state (English vs Arabic).
class LanguageController extends GetxController {
  static const String english = 'en';
  static const String arabic = 'ar';

  /// The current active language code.
  final RxString currentLanguage = english.obs;

  /// Returns [true] if the current language is Arabic.
  bool get isArabic => currentLanguage.value == arabic;

  /// Returns [true] if the current language is English.
  bool get isEnglish => currentLanguage.value == english;

  /// Switches the application locale to the specified [languageCode].
  void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }

  /// Toggles between English and Arabic.
  void toggleLanguage() {
    if (isEnglish) {
      changeLanguage(arabic);
    } else {
      changeLanguage(english);
    }
  }

  /// Sets the application language to English.
  void setEnglish() => changeLanguage(english);

  /// Sets the application language to Arabic.
  void setArabic() => changeLanguage(arabic);
}
