import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../gen/assets.gen.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../homepage/widgets/footer_section.dart';

class ConfirmedScreen extends StatelessWidget {
  const ConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderNumber = '158';
    final savedAmount = '2.000';

    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Container(
                    width: 220.w,
                    height: 220.w,
                    decoration: BoxDecoration(
                      color: AppColors.GREEN.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Assets.svg.orderConfirmed.svg(
                        width: 120.w,
                        height: 120.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 48.h),
                  Text(
                    'YAY!\nYOUR ORDER IS CONFIRMED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 52.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.GREEN,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'GREAT! YOU SAVED BHD $savedAmount ON THIS ORDER',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.GREY,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ORDER NUMBER',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.BLACK,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 38.w,
                          vertical: 24.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x4DF7BE26),
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: AppColors.YELLOW,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          orderNumber,
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.BLACK,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: AppColors.WHITE,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.GREY_LIGHT, width: 1),
                    ),
                    child: Column(
                      children: [
                        QrImageView(
                          data: 'https://chicket.com/receipt/$orderNumber',
                          version: QrVersions.auto,
                          size: 180.w,
                          backgroundColor: AppColors.WHITE,
                        ),
                        SizedBox(height: 24.h),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'SCAN FOR ',
                                style: TextStyle(color: AppColors.GREY),
                              ),
                              TextSpan(
                                text: 'E-RECEIPT',
                                style: TextStyle(color: AppColors.GREEN),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'E-RECEIPT ',
                                style: TextStyle(color: AppColors.GREEN),
                              ),
                              TextSpan(
                                text: 'SENT TO YOUR NUMBER',
                                style: TextStyle(color: AppColors.GREY),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    'COLLECT YOUR ORDER\nAT THE COUNTER WHEN IT\'S READY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.BLACK,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(Routes.home);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 26.w,
                        vertical: 19.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.BROWN,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'THANK YOU !',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.YELLOW,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
