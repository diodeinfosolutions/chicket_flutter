import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/order_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../../models/menu_model.dart';
import '../../../theme/colors.dart';
import 'addon_bottom_sheet.dart';

class RepeatOrCustomizeSheet extends StatelessWidget {
  final Product product;

  const RepeatOrCustomizeSheet({super.key, required this.product});

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
            decoration: const BoxDecoration(
              color: AppColors.GREY_LIGHT,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Assets.svg.repeat.svg(
                width: 100.w,
                height: 100.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.GREY,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            'WOULD YOU LIKE TO REPEAT THE SAME ITEM\nOR CUSTOMIZE IT?',
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
                  onPressed: () {
                    final lastIndex = orderController.cart.lastIndexWhere(
                      (e) => e['productId'] == product.id,
                    );
                    if (lastIndex != -1) {
                      final lastItem = orderController.cart[lastIndex];
                      final addons =
                          lastItem['addons']
                              as Map<String, List<Map<String, dynamic>>>;

                      orderController.addToCart(
                        productId: product.id,
                        name: product.name,
                        price: product.price,
                        addons: Map<String, List<Map<String, dynamic>>>.from(
                          addons.map(
                            (key, value) => MapEntry(
                              key,
                              value
                                  .map((e) => Map<String, dynamic>.from(e))
                                  .toList(),
                            ),
                          ),
                        ),
                      );
                    }
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.BROWN,
                    side: const BorderSide(color: AppColors.BROWN, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'REPEAT',
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
                    Get.back();
                    showAddonBottomSheet(context, product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.BROWN,
                    foregroundColor: AppColors.YELLOW,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'CUSTOMIZE',
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

void showRepeatOrCustomizeSheet(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
    builder: (context) => RepeatOrCustomizeSheet(product: product),
  );
}
