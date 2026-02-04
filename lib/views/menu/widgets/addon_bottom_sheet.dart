import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/order_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../../api/models/menu_models.dart';

class AddonBottomSheet extends StatelessWidget {
  final MenuItem product;

  const AddonBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final description = product.description ?? '';
    final productName = product.name ?? '';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(64.w),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'your_cart'.tr,
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: product.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        width: 220.w,
                        height: 200.h,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          width: 220.w,
                          height: 200.h,
                          color: Colors.grey[200],
                          child: Icon(Icons.restaurant, size: 48.w),
                        ),
                        errorWidget: (_, _, _) => Container(
                          width: 220.w,
                          height: 200.h,
                          color: Colors.grey[200],
                          child: Icon(Icons.restaurant, size: 48.w),
                        ),
                      )
                    : Container(
                        width: 220.w,
                        height: 200.h,
                        color: Colors.grey[200],
                        child: Icon(Icons.restaurant, size: 48.w),
                      ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFF7BE26),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      description.toUpperCase(),
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
                    ...?product.modifierGroups?.map(
                      (modGroup) => _buildModifierGroup(
                        modGroup,
                        orderController,
                      ),
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
                            'add_to_cart'.tr,
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

  Widget _buildModifierGroup(
    MenuModifierGroup modGroup,
    OrderController orderController,
  ) {
    final groupName = modGroup.name ?? 'Options';
    final isRequired = modGroup.required ?? false;
    final groupId = modGroup.id ?? '';

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                groupName.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF283034),
                ),
              ),
              if (isRequired) ...[
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
              children:
                  modGroup.items?.map((modItem) {
                    final modName = modItem.name ?? 'Option';
                    final modPrice = (modItem.price ?? 0).toDouble();
                    final modId = modItem.id;

                    final isSelected = orderController.isModifierSelected(
                      groupId,
                      modId,
                    );
                    return GestureDetector(
                      onTap: () => orderController.toggleModifier(
                        groupId,
                        modId,
                        modName,
                        modPrice,
                        modGroup.maxQuantity ?? 999,
                      ),
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
                          modName.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF642F21),
                          ),
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
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

void showAddonBottomSheet(BuildContext context, MenuItem product) {
  final orderController = Get.find<OrderController>();
  orderController.initModifierSelectionForMenuItem(product);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
    builder: (context) => AddonBottomSheet(product: product),
  );
}
