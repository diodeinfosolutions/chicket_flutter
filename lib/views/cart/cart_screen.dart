import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/language_controller.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/syrve_controller.dart';
import '../../gen/assets.gen.dart';
import '../../api/models/view_menu_models.dart';
import '../../routes.dart';
import '../../theme/colors.dart';
import '../../utils/cache_config.dart';
import '../menu/widgets/addon_bottom_sheet.dart';
import '../menu/widgets/clear_cart_sheet.dart';
import '../menu/widgets/repeat_or_customize_sheet.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final syrveController = Get.find<SyrveController>();

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
                          'your_cart'.tr,
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
                                syrveController,
                                context,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 0.075.sh),
                    Text(
                      'recommended_for_you'.tr,
                      style: TextStyle(
                        fontFamily: 'Oswald',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF283034),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildRecommendedSection(
                      orderController,
                      syrveController,
                      context,
                    ),
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
    SyrveController syrveController,
    BuildContext context,
  ) {
    final isArabic = Get.find<LanguageController>().isArabic;
    final productId = item['productId'] as String;
    final menuItem = syrveController.getMenuItemById(productId);

    final productName =
        (isArabic &&
            menuItem?.nameAr != null &&
            menuItem!.nameAr!.trim().isNotEmpty)
        ? menuItem.nameAr!
        : (menuItem?.name ?? 'Unknown');
    final productDescription =
        (isArabic &&
            menuItem?.descriptionAr != null &&
            menuItem!.descriptionAr!.trim().isNotEmpty)
        ? menuItem.descriptionAr!
        : (menuItem?.description ?? '');

    final defaultSize =
        menuItem?.itemSizes?.firstWhereOrNull((s) => s.isDefault == true) ??
        menuItem?.itemSizes?.firstOrNull;
    final productImageUrl = defaultSize?.buttonImageUrl;

    final qty = item['qty'] as int;
    final modifiers =
        item['modifiers'] as Map<String, List<Map<String, dynamic>>>?;

    final priceString = defaultSize?.prices?.firstOrNull?.price ?? '0';
    double itemPrice = double.tryParse(priceString) ?? 0.0;
    if (modifiers != null) {
      for (final group in modifiers.values) {
        for (final mod in group) {
          itemPrice += (mod['price'] as double?) ?? 0.0;
        }
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: productImageUrl != null
                ? CachedNetworkImage(
                    imageUrl: productImageUrl,
                    width: 160.w,
                    height: 140.h,
                    fit: BoxFit.cover,
                    cacheManager: CacheConfig.optimizedCacheManager,
                    placeholder: (context, url) => Container(
                      width: 160.w,
                      height: 140.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.restaurant, size: 32.w),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 160.w,
                      height: 140.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.restaurant, size: 32.w),
                    ),
                  )
                : Container(
                    width: 160.w,
                    height: 140.h,
                    color: Colors.grey[200],
                    child: Icon(Icons.restaurant, size: 32.w),
                  ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFF7BE26),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  productDescription.toUpperCase(),
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
                if (modifiers != null && modifiers.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _buildModifierChips(modifiers),
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
                    _buildQuantitySelector(
                      index,
                      qty,
                      orderController,
                      modifiers,
                      menuItem,
                      context,
                    ),
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

  List<Widget> _buildModifierChips(
    Map<String, List<Map<String, dynamic>>> modifiers,
  ) {
    final chips = <Widget>[];
    for (final group in modifiers.values) {
      for (final mod in group) {
        chips.add(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0x1A642F21),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF642F21), width: 1),
            ),
            child: Text(
              ((mod['name'] as String?) ?? '').toUpperCase(),
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
    Map<String, List<Map<String, dynamic>>>? modifiers,
    ViewMenuItem? product,
    BuildContext context,
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
          onTap: () {
            if (modifiers != null && modifiers.isNotEmpty && product != null) {
              showRepeatOrCustomizeSheet(
                context,
                product,
                modifiers: modifiers,
              );
            } else {
              orderController.increaseQty(index);
            }
          },
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
    SyrveController syrveController,
    BuildContext context,
  ) {
    final allProducts = syrveController.menuItems;
    final cartProductIds = orderController.cart
        .map((e) => e['productId'] as String)
        .toSet();
    final filtered = allProducts
        .where((p) => !cartProductIds.contains(p.itemId ?? p.sku ?? ''))
        .toList();
    filtered.shuffle();
    final recommended = filtered.take(4).toList();

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
    ViewMenuItem product,
    OrderController orderController,
    BuildContext context,
  ) {
    final isArabic = Get.find<LanguageController>().isArabic;
    final productName =
        (isArabic &&
            product.nameAr != null &&
            product.nameAr!.trim().isNotEmpty)
        ? product.nameAr!
        : (product.name ?? '');
    final description =
        (isArabic &&
            product.descriptionAr != null &&
            product.descriptionAr!.trim().isNotEmpty)
        ? product.descriptionAr!
        : (product.description ?? '');

    final defaultSize =
        product.itemSizes?.firstWhereOrNull((s) => s.isDefault == true) ??
        product.itemSizes?.firstOrNull;
    final priceString = defaultSize?.prices?.firstOrNull?.price ?? '0';
    final price = double.tryParse(priceString) ?? 0.0;
    final productImageUrl = defaultSize?.buttonImageUrl;

    return Container(
      width: 280.w,
      margin: EdgeInsetsDirectional.only(end: 24.w),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: AspectRatio(
              aspectRatio: 1,
              child: productImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: productImageUrl,
                      fit: BoxFit.cover,
                      cacheManager: CacheConfig.optimizedCacheManager,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.restaurant, size: 32.w),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.restaurant, size: 32.w),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.restaurant, size: 32.w),
                    ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            productName.toUpperCase(),
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
              description.toUpperCase(),
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
            'BHD ${price.toStringAsFixed(3)}',
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          _buildCartButton(context, orderController, price, product),
        ],
      ),
    );
  }

  Widget _buildCartButton(
    BuildContext context,
    OrderController orderController,
    double price,
    ViewMenuItem product,
  ) {
    final hasModifiers =
        (product.itemSizes?.any(
          (s) => (s.itemModifierGroups?.isNotEmpty ?? false),
        ) ??
        false);
    return Obx(() {
      final productId = product.itemId ?? product.sku ?? '';
      final totalQty = orderController.getProductQuantity(productId);

      final cartIndexNoAddons = orderController.cart.indexWhere(
        (e) =>
            e['productId'] == productId &&
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
                      (e) => e['productId'] == productId,
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
                productId: productId,
                name: product.name ?? '',
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
            GestureDetector(
              onTap: () {
                Get.offAllNamed(Routes.menu);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF642F21),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'menu'.tr,
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFF7BE26),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
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
                          'items_added_to_cart'.tr,
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
                              'total'.tr,
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
                      'items_added'.tr,
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
                    'cancel_order'.tr,
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
                    'proceed'.tr,
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
