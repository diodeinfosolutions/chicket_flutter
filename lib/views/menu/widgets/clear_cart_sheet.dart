import 'package:chicket/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/order_controller.dart';
import '../../../gen/assets.gen.dart';

class ClearCartSheet extends StatelessWidget {
  final VoidCallback? onDeleted;

  const ClearCartSheet({super.key, this.onDeleted});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 48.h),
      decoration: const BoxDecoration(color: AppColors.WHITE),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              color: AppColors.RED.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Assets.svg.clearCart.svg(
                width: 100.w,
                height: 100.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.RED,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            'clear_cart_question'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.BLACK,
            ),
          ),
          SizedBox(height: 40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200.w,
                height: 72.h,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.BROWN, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'no'.tr,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 24.w),
              SizedBox(
                width: 200.w,
                height: 72.h,
                child: ElevatedButton(
                  onPressed: () {
                    orderController.clearCart();
                    Get.back();
                    onDeleted?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.RED,
                    foregroundColor: AppColors.WHITE,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'delete'.tr,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

void showClearCartSheet(BuildContext context, {VoidCallback? onDeleted}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
    builder: (context) => ClearCartSheet(onDeleted: onDeleted),
  );
}
