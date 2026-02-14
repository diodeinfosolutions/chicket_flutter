import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// TODO: Re-enable when receipt URL is available
// import 'package:qr_flutter/qr_flutter.dart';

import '../../controllers/order_controller.dart';
import '../../controllers/syrve_controller.dart';
import '../../gen/assets.gen.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../homepage/widgets/footer_section.dart';

class ConfirmedScreen extends StatelessWidget {
  const ConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syrveController = Get.find<SyrveController>();
    final orderController = Get.find<OrderController>();

    final orderResponse = syrveController.lastOrderResponse.value;
    final orderDetails = orderResponse?.orderInfo?.order;

    // Use order.number if available, otherwise generate from posId last 4 chars
    String orderNumber = '-';
    if (orderDetails?.number != null) {
      orderNumber = orderDetails!.number.toString();
    } else if (orderResponse?.orderInfo?.posId != null) {
      // Use last 4 characters of posId as display number
      final posId = orderResponse!.orderInfo!.posId!;
      orderNumber = posId.length >= 4
          ? posId.substring(posId.length - 4).toUpperCase()
          : posId.toUpperCase();
    }

    // Keep orderId for future use when receipt URL is available
    // final orderId = orderResponse?.orderInfo?.id ?? '';

    final discounts = orderDetails?.discounts ?? [];
    final totalSavings = discounts.fold<num>(0, (sum, d) => sum + (d.sum ?? 0));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: AppColors.WHITE,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      'yay_order_confirmed'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 52.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.GREEN,
                      ),
                    ),
                    if (totalSavings > 0) ...[
                      SizedBox(height: 16.h),
                      Text(
                        'saved_on_order'.trParams({
                          'amount': totalSavings.toStringAsFixed(3),
                        }),
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.GREY,
                        ),
                      ),
                    ],
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'order_number'.tr,
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
                    // TODO: Enable QR code when receipt URL is available
                    // SizedBox(height: 40.h),
                    // Container(
                    //   padding: EdgeInsets.all(32.w),
                    //   decoration: BoxDecoration(
                    //     color: AppColors.WHITE,
                    //     borderRadius: BorderRadius.circular(16.r),
                    //     border: Border.all(
                    //       color: AppColors.GREY_LIGHT,
                    //       width: 1,
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       QrImageView(
                    //         data: orderId.isNotEmpty
                    //             ? 'https://chicket.com/receipt/$orderId'
                    //             : 'https://chicket.com/order/$orderNumber',
                    //         version: QrVersions.auto,
                    //         size: 180.w,
                    //         backgroundColor: AppColors.WHITE,
                    //       ),
                    //       SizedBox(height: 24.h),
                    //       RichText(
                    //         text: TextSpan(
                    //           style: TextStyle(
                    //             fontFamily: 'Oswald',
                    //             fontSize: 28.sp,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //           children: [
                    //             TextSpan(
                    //               text: 'scan_for'.tr,
                    //               style: TextStyle(color: AppColors.GREY),
                    //             ),
                    //             TextSpan(
                    //               text: 'e_receipt'.tr,
                    //               style: TextStyle(color: AppColors.GREEN),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       SizedBox(height: 8.h),
                    //       RichText(
                    //         text: TextSpan(
                    //           style: TextStyle(
                    //             fontFamily: 'Oswald',
                    //             fontSize: 24.sp,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //           children: [
                    //             TextSpan(
                    //               text: 'e_receipt'.tr,
                    //               style: TextStyle(color: AppColors.GREEN),
                    //             ),
                    //             TextSpan(
                    //               text: ' ${'sent_to_number'.tr}',
                    //               style: TextStyle(color: AppColors.GREY),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 40.h),
                    Text(
                      'collect_order'.tr,
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
                        // Clear cart and reset order data
                        orderController.resetSelection();
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
                          'thank_you'.tr,
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
      ),
    );
  }
}
