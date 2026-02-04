import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/order_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../../models/menu_model.dart';

class AddonBottomSheet extends StatelessWidget {
  final Product product;

  const AddonBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(64.w),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR CART',
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 40.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF283034),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      product.image,
                      width: 220.w,
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: product.foodType == FoodType.veg
                        ? Assets.svg.veg.svg(width: 24.w, height: 24.w)
                        : Assets.svg.non.svg(width: 24.w, height: 24.w),
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFF7BE26),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      product.description.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF757575),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 16.h),
                    ...product.addonGroups.map(
                      (group) => _buildAddonGroup(group, orderController),
                    ),
                    SizedBox(height: 16.h),
                    Obx(
                      () => Row(
                        children: [
                          SizedBox(
                            width: 224.w,
                            child: Text(
                              'BHD ${orderController.addonTotalPrice.toStringAsFixed(3)}',
                              style: TextStyle(
                                fontFamily: 'Oswald',
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF283034),
                              ),
                            ),
                          ),
                          SizedBox(width: 24.w),
                          _buildQuantitySelector(orderController),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Obx(
                      () => SizedBox(
                        width: 220.w,
                        height: 72.h,
                        child: ElevatedButton(
                          onPressed: orderController.canAddToCart
                              ? orderController.addCurrentProductToCart
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF642F21),
                            foregroundColor: const Color(0xFFF7BE26),
                            disabledBackgroundColor: const Color(
                              0xFF642F21,
                            ).withValues(alpha: 0.5),
                            disabledForegroundColor: const Color(
                              0xFFF7BE26,
                            ).withValues(alpha: 0.5),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                          child: Text(
                            'ADD TO CART',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  orderController.resetAddonSelection();
                  Get.back();
                },
                child: Assets.svg.delete.svg(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddonGroup(AddonGroup group, OrderController orderController) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                group.title.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF283034),
                ),
              ),
              if (group.required) ...[
                SizedBox(width: 8.w),
                Text(
                  '*',
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFDD2229),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Wrap(
              spacing: 12.w,
              runSpacing: 8.h,
              children: group.addons.map((addon) {
                final isSelected = orderController.isAddonSelected(
                  group.id,
                  addon.id,
                );
                return GestureDetector(
                  onTap: () => orderController.toggleAddon(group, addon),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0x1A642F21)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF642F21)
                            : const Color(0xFF757575),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      addon.name.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF642F21),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(OrderController orderController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: orderController.decrementAddonQuantity,
          child: Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: const Color(0xFF642F21),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Text(
                '−',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF7BE26),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Obx(
          () => Container(
            width: 80.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '${orderController.addonQuantity.value}',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF283034),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: orderController.incrementAddonQuantity,
          child: Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: const Color(0xFF642F21),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFF7BE26),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showAddonBottomSheet(BuildContext context, Product product) {
  final orderController = Get.find<OrderController>();
  orderController.initAddonSelection(product);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
    builder: (context) => AddonBottomSheet(product: product),
  );
}
