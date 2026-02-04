import 'dart:ui';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  static const String english = 'en';
  static const String arabic = 'ar';

  final RxString currentLanguage = english.obs;

  bool get isArabic => currentLanguage.value == arabic;
  bool get isEnglish => currentLanguage.value == english;

  void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }

  void toggleLanguage() {
    if (isEnglish) {
      changeLanguage(arabic);
    } else {
      changeLanguage(english);
    }
  }

  void setEnglish() => changeLanguage(english);
  void setArabic() => changeLanguage(arabic);
}
