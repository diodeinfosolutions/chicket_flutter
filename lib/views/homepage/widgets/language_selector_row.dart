import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/colors.dart';

enum AppLanguage { english, arabic }

class LanguageSelectorRow extends StatefulWidget {
  final bool isTabletPortrait;

  const LanguageSelectorRow({super.key, this.isTabletPortrait = false});

  @override
  State<LanguageSelectorRow> createState() => _LanguageSelectorRowState();
}

class _LanguageSelectorRowState extends State<LanguageSelectorRow> {
  AppLanguage _selectedLanguage = AppLanguage.english;

  void _handleSelection(AppLanguage language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.isTabletPortrait ? 24.sp : 36.sp;
    final dividerHeight = widget.isTabletPortrait ? 28.h : 40.h;
    final horizontalMargin = widget.isTabletPortrait ? 16.w : 24.w;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _handleSelection(AppLanguage.english),
          child: Text(
            'ENGLISH',
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: _selectedLanguage == AppLanguage.english
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
          onTap: () => _handleSelection(AppLanguage.arabic),
          child: Text(
            'عربي',
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: _selectedLanguage == AppLanguage.arabic
                  ? AppColors.RED
                  : AppColors.BLACK,
            ),
          ),
        ),
      ],
    );
  }
}
