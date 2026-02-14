import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/language_controller.dart';
import '../../../theme/colors.dart';

class LanguageSelectorRow extends StatelessWidget {
  final bool isTabletPortrait;

  const LanguageSelectorRow({super.key, this.isTabletPortrait = false});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    final fontSize = isTabletPortrait ? 24.sp : 36.sp;
    final dividerHeight = isTabletPortrait ? 28.h : 40.h;
    final horizontalMargin = isTabletPortrait ? 16.w : 24.w;

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => languageController.setEnglish(),
            child: Text(
              'english'.tr,
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: languageController.isEnglish
                    ? AppColors.RED
                    : AppColors.BLACK,
              ),
            ),
          ),
          Container(
            width: 2.w,
            height: dividerHeight,
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
            color: const Color(0xFFD9D9D9),
          ),
          GestureDetector(
            onTap: () => languageController.setArabic(),
            child: Text(
              'arabic'.tr,
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: languageController.isArabic
                    ? AppColors.RED
                    : AppColors.BLACK,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
