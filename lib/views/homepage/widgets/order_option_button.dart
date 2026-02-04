import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/colors.dart';
import '../../../utils/color_filter.dart';

class OrderOptionButton extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isTabletPortrait;
  final String label;

  const OrderOptionButton({
    super.key,
    required this.child,
    this.isSelected = false,
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
        child: ColorFiltered(
          colorFilter: getColorFilter(
            isSelected ? AppColors.RED : AppColors.BLACK,
          ),
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
                  color: isSelected ? AppColors.RED : AppColors.BLACK,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
