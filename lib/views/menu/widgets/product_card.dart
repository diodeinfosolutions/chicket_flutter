import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/order_controller.dart';
import '../../../api/models/menu_models.dart';
import '../../../utils/cache_config.dart';
import 'addon_bottom_sheet.dart';
import 'repeat_or_customize_sheet.dart';

class ProductCard extends StatelessWidget {
  final MenuItem product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final price = (product.currentPrice ?? 0).toDouble();
    final description = product.description ?? '';
    final productName = product.name ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: product.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      fit: BoxFit.cover,
                      cacheManager: CacheConfig.optimizedCacheManager,
                      placeholder: (_, _) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.restaurant,
                          size: 48.w,
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.restaurant,
                          size: 48.w,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.restaurant,
                        size: 48.w,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 18.sp * 1.3 * 2,
                  child: Text(
                    productName.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFF7BE26),
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 12.sp * 1.3 * 4,
                  child: Text(
                    description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF757575),
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'BHD ${price.toStringAsFixed(3)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF283034),
                  ),
                ),
                SizedBox(height: 8.h),
                _buildCartButton(context, orderController, price, productName),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartButton(
    BuildContext context,
    OrderController orderController,
    double price,
    String productName,
  ) {
    final hasModifiers =
        (product.itemSizes?.any(
              (s) => (s.itemModifierGroups?.isNotEmpty ?? false),
            ) ??
            false) ||
        (product.modifierGroups?.isNotEmpty ?? false);
    return Obx(() {
      final totalQty = orderController.getProductQuantity(product.id);

      final cartIndexNoAddons = orderController.cart.indexWhere(
        (e) =>
            e['productId'] == product.id &&
            ((e['modifiers'] as Map?)?.isEmpty ?? true),
      );

      if (totalQty > 0) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (hasModifiers) {
                    final lastIndex = orderController.cart.lastIndexWhere(
                      (e) => e['productId'] == product.id,
                    );
                    if (lastIndex != -1) {
                      orderController.decreaseQty(lastIndex);
                    }
                  } else {
                    orderController.decreaseQty(cartIndexNoAddons);
                  }
                },
                child: Container(
                  height: 64.h,
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
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 2,
              child: Container(
                height: 64.h,
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
                    '$totalQty',
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
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Always show RepeatOrCustomizeSheet for items with modifiers
                  if (hasModifiers) {
                    showRepeatOrCustomizeSheet(context, product);
                  } else {
                    orderController.increaseQty(cartIndexNoAddons);
                  }
                },
                child: Container(
                  height: 64.h,
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
            ),
          ],
        );
      }

      return SizedBox(
        width: double.infinity,
        height: 64.h,
        child: ElevatedButton(
          onPressed: () {
            if (hasModifiers) {
              showAddonBottomSheet(context, product);
            } else {
              orderController.addToCart(
                productId: product.id,
                name: productName,
                price: price,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF642F21),
            foregroundColor: const Color(0xFFF7BE26),
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
      );
    });
  }
}
