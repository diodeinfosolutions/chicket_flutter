import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme/colors.dart';

class OrderTextSection extends StatelessWidget {
  final bool isTabletPortrait;

  const OrderTextSection({super.key, this.isTabletPortrait = false});

  @override
  Widget build(BuildContext context) {
    final titleFontSize = isTabletPortrait ? 80.sp : 120.sp;
    final subtitleFontSize = isTabletPortrait ? 36.sp : 56.sp;

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'order_here'.tr,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: titleFontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.BLACK,
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'to_skip_queue'.tr,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.BLACK,
            ),
          ),
        ),
      ],
    );
  }
}
