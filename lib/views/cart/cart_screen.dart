import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/order_controller.dart';
import '../../gen/assets.gen.dart';
import '../../models/menu_model.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../menu/widgets/addon_bottom_sheet.dart';
import '../menu/widgets/clear_cart_sheet.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                        SizedBox(width: 16.w),
                        Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x4DF7BE26),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFFF7BE26),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${orderController.cartItemCount}',
                              style: TextStyle(
                                fontFamily: 'Oswald',
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF283034),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Divider(color: AppColors.GREY_LIGHT),
                    SizedBox(height: 24.h),
                    Obx(
                      () => Column(
                        children: orderController.cart
                            .asMap()
                            .entries
                            .map(
                              (entry) => _buildCartItem(
                                entry.key,
                                entry.value,
                                orderController,
                                context,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 0.075.sh),
                    Text(
                      'RECOMMENDED FOR YOU',
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF283034),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildRecommendedSection(orderController, context),
                  ],
                ),
              ),
            ),
            _buildBottomBar(orderController, context),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(
    int index,
    Map<String, dynamic> item,
    OrderController orderController,
    BuildContext context,
  ) {
    final productId = item['productId'] as String;
    final product = products.firstWhere((p) => p.id == productId);
    final qty = item['qty'] as int;
    final addons = item['addons'] as Map<String, List<Map<String, dynamic>>>;

    double itemPrice = product.price;
    for (final group in addons.values) {
      for (final addon in group) {
        itemPrice += addon['price'] as double;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  product.image,
                  width: 160.w,
                  height: 140.h,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: product.foodType == FoodType.veg
                    ? Assets.svg.veg.svg(width: 20.w, height: 20.w)
                    : Assets.svg.non.svg(width: 20.w, height: 20.w),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFF7BE26),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  product.description.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (addons.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _buildAddonChips(addons),
                  ),
                ],
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Text(
                      'BHD ${(itemPrice * qty).toStringAsFixed(3)}',
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF283034),
                      ),
                    ),
                    SizedBox(width: 24.w),
                    _buildQuantitySelector(index, qty, orderController),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => orderController.removeItem(index),
            child: Assets.svg.delete.svg(width: 32.w, height: 32.w),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAddonChips(
    Map<String, List<Map<String, dynamic>>> addons,
  ) {
    final chips = <Widget>[];
    for (final group in addons.values) {
      for (final addon in group) {
        chips.add(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0x1A642F21),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF642F21), width: 1),
            ),
            child: Text(
              (addon['name'] as String).toUpperCase(),
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF642F21),
              ),
            ),
          ),
        );
      }
    }

    return chips;
  }

  Widget _buildQuantitySelector(
    int index,
    int qty,
    OrderController orderController,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => orderController.decreaseQty(index),
          child: Container(
            width: 64.w,
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
        SizedBox(width: 8.w),
        Container(
          width: 72.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(
              '$qty',
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF283034),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () => orderController.increaseQty(index),
          child: Container(
            width: 64.w,
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
      ],
    );
  }

  Widget _buildRecommendedSection(
    OrderController orderController,
    BuildContext context,
  ) {
    final cartProductIds = orderController.cart
        .map((e) => e['productId'] as String)
        .toSet();
    final recommended = products
        .where((p) => !cartProductIds.contains(p.id))
        .take(4)
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: recommended
            .map(
              (product) =>
                  _buildRecommendedCard(product, orderController, context),
            )
            .toList(),
      ),
    );
  }

  Widget _buildRecommendedCard(
    Product product,
    OrderController orderController,
    BuildContext context,
  ) {
    final hasAddons = product.addonGroups.isNotEmpty;

    return Obx(() {
      final totalQty = orderController.getProductQuantity(product.id);

      return Container(
        width: 280.w,
        margin: EdgeInsets.only(right: 24.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(product.image, fit: BoxFit.cover),
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
            SizedBox(height: 16.h),
            Text(
              product.name.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFF7BE26),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 12.sp * 1.3 * 3,
              child: Text(
                product.description.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF757575),
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'BHD ${product.price.toStringAsFixed(3)}',
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            if (hasAddons)
              _buildRecommendedAddToCartButton(product, context)
            else
              _buildRecommendedQuantitySelector(
                product,
                totalQty,
                orderController,
                context,
              ),
          ],
        ),
      );
    });
  }

  Widget _buildRecommendedAddToCartButton(
    Product product,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 64.h,
      child: ElevatedButton(
        onPressed: () => showAddonBottomSheet(context, product),
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
          'ADD TO CART',
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedQuantitySelector(
    Product product,
    int qty,
    OrderController orderController,
    BuildContext context,
  ) {
    final cartIndexNoAddons = orderController.cart.indexWhere(
      (e) => e['productId'] == product.id && (e['addons'] as Map).isEmpty,
    );

    if (qty > 0) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (cartIndexNoAddons != -1) {
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
                  '$qty',
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
                if (cartIndexNoAddons != -1) {
                  orderController.increaseQty(cartIndexNoAddons);
                } else {
                  orderController.addToCart(
                    productId: product.id,
                    name: product.name,
                    price: product.price,
                  );
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
          orderController.addToCart(
            productId: product.id,
            name: product.name,
            price: product.price,
          );
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
          'ADD TO CART',
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    OrderController orderController,
    BuildContext context,
  ) {
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
            Container(
              width: 0.1.sh,
              padding: EdgeInsets.symmetric(vertical: 22.w, horizontal: 44.w),
              decoration: BoxDecoration(
                color: const Color(0x4DF7BE26),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFF7BE26), width: 1),
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
                          crossAxisAlignment: CrossAxisAlignment.baseline,
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
            if (itemCount > 0) ...[
              GestureDetector(
                onTap: () {
                  showClearCartSheet(context, onDeleted: () => Get.back());
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
                    'PROCEED',
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
