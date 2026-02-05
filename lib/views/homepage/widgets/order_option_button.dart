import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/colors.dart';

class OrderOptionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isTabletPortrait;
  final String label;

  const OrderOptionButton({
    super.key,
    required this.child,
    this.onTap,
    this.isTabletPortrait = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final padding = isTabletPortrait ? 20.w : 32.w;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        color: AppColors.WHITE,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            child,
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color:  AppColors.BLACK,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
