import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/order_controller.dart';
import '../../../routes.dart';
import 'clear_cart_sheet.dart';

class CartBottomBar extends StatelessWidget {
  const CartBottomBar({
    super.key,
    this.hideButtons = false,
    this.customActionButton,
  });
  final bool hideButtons;
  final Widget? customActionButton;

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    return Obx(() {
      final itemCount = orderController.cartItemCount;
      final total = orderController.cartTotal;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: itemCount > 0 ? () => Get.toNamed(Routes.cart) : null,
                child: Row(
                  children: [
                    Container(
                      width: 0.1.sh,
                      padding: EdgeInsets.symmetric(
                        vertical: 22.w,
                        horizontal: 44.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x4DF7BE26),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFF7BE26),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$itemCount',
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF283034),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Expanded(
                      child: itemCount > 0
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ITEMS ADDED TO YOUR CART',
                                  style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF283034),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      'TOTAL:',
                                      style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF283034),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'BHD ${total.toStringAsFixed(3)}',
                                      style: TextStyle(
                                        fontFamily: 'Oswald',
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF642F21),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Text(
                              'Items has been added to the cart',
                              style: TextStyle(
                                fontFamily: 'Oswald',
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            if (customActionButton != null)
              customActionButton!
            else if (!hideButtons && itemCount > 0) ...[
              GestureDetector(
                onTap: () {
                  showClearCartSheet(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFF642F21),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'CANCEL ORDER',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF642F21),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.mob),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF642F21),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'PLACE ORDER',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFF7BE26),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
