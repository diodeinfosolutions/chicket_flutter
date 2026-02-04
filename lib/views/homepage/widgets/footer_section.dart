import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/colors.dart';

class FooterSection extends StatelessWidget {
  final bool isTabletPortrait;

  const FooterSection({super.key, this.isTabletPortrait = false});

  @override
  Widget build(BuildContext context) {
    final fontSize = isTabletPortrait ? 16.sp : 24.sp;
    final horizontalPadding = isTabletPortrait ? 0.04.sw : 0.065.sw;
    final bottomPadding = isTabletPortrait ? 0.02.sh : 0.031.sh;
    final itemSpacing = isTabletPortrait ? 10.w : 16.w;

    final textStyle = TextStyle(
      fontFamily: 'Oswald',
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: AppColors.GREY,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: bottomPadding,
      ),
      child: SizedBox(
        width: 1.sw,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('WWW.CHICKETARABIA.COM', style: textStyle),
            const Spacer(),
            Row(
              children: [
                Text('BAHRAIN', style: textStyle),
                Container(
                  width: 1.w,
                  height: fontSize,
                  margin: EdgeInsets.symmetric(horizontal: itemSpacing),
                  color: const Color(0xFFD9D9D9),
                ),
                Text('SAUDI ARABIA', style: textStyle),
                Container(
                  width: 1.w,
                  height: fontSize,
                  margin: EdgeInsets.symmetric(horizontal: itemSpacing),
                  color: const Color(0xFFD9D9D9),
                ),
                Text('UAE', style: textStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
