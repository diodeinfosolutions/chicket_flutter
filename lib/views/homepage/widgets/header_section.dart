import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes.dart';
import '../../../theme/colors.dart';

class HeaderSection extends StatefulWidget {
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
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  int _tapCount = 0;
  DateTime? _lastTapTime;
  static const int _requiredTaps = 5;
  static const Duration _tapTimeout = Duration(seconds: 2);

  void _handleLogoTap() {
    final now = DateTime.now();

    if (_lastTapTime != null && now.difference(_lastTapTime!) > _tapTimeout) {
      _tapCount = 0;
    }

    _tapCount++;
    _lastTapTime = now;

    if (_tapCount >= _requiredTaps) {
      _tapCount = 0;
      _lastTapTime = null;
      Get.toNamed(Routes.setup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleFontSize = widget.isTabletPortrait ? 48.sp : 72.sp;
    final subtitleFontSize = widget.isTabletPortrait ? 38.sp : 58.sp;

    return Container(
      height: widget.heightFactor.sh,
      width: 1.sw,
      color: AppColors.RED,
      child: Column(
        children: [
          Gap(widget.isTabletPortrait ? 0.015.sh : 0.03.sh),
          Expanded(
            child: GestureDetector(
              onTap: _handleLogoTap,
              child: SizedBox(
                width: 1.sw,
                child: GifView.asset(
                  Assets.gif.chicket.path,
                  controller: widget.gifController,
                  fit: BoxFit.cover,
                  loop: true,
                ),
              ),
            ),
          ),
          Gap(widget.isTabletPortrait ? 0.01.sh : 0.02.sh),
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
          Gap(widget.isTabletPortrait ? 0.015.sh : 0.03.sh),
        ],
      ),
    );
  }
}
