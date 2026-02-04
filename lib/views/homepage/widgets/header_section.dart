import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gif_view/gif_view.dart';

import '../../../gen/assets.gen.dart';
import '../../../theme/colors.dart';

class HeaderSection extends StatelessWidget {
  final GifController gifController;
  final double heightFactor;
  final bool isTabletPortrait;

  const HeaderSection({
    super.key,
    required this.gifController,
    this.heightFactor = 0.44,
    this.isTabletPortrait = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleFontSize = isTabletPortrait ? 48.sp : 72.sp;
    final subtitleFontSize = isTabletPortrait ? 38.sp : 58.sp;

    return Container(
      height: heightFactor.sh,
      width: 1.sw,
      color: AppColors.RED,
      child: Column(
        children: [
          Gap(isTabletPortrait ? 0.015.sh : 0.03.sh),
          Expanded(
            child: SizedBox(
              width: 1.sw,
              child: GifView.asset(
                Assets.gif.chicket.path,
                controller: gifController,
                fit: BoxFit.cover,
                loop: true,
              ),
            ),
          ),
          Gap(isTabletPortrait ? 0.01.sh : 0.02.sh),
          Text(
            "Chicket Arabia",
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: titleFontSize,
              fontWeight: FontWeight.w700,
              color: AppColors.WHITE,
            ),
          ),
          Text(
            "Best broasted and fried chicken",
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.WHITE,
            ),
          ),
          Gap(isTabletPortrait ? 0.015.sh : 0.03.sh),
        ],
      ),
    );
  }
}
