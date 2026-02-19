import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../controllers/language_controller.dart';
import '../../controllers/syrve_controller.dart';
import '../../controllers/banner_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../gen/assets.gen.dart';
import '../../utils/cache_config.dart';
import '../../api/models/menu_models.dart';
import 'widgets/cart_bottom_bar.dart';
import 'widgets/category_widget.dart';
import 'widgets/menu_shimmer.dart';
import 'widgets/product_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategoryId = 'all';
  final SyrveController _syrveController = Get.find<SyrveController>();
  final LanguageController _languageController = Get.find<LanguageController>();
  final BannerController _bannerController = Get.find<BannerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Obx(() {
        final allCategories = _syrveController.menuCategories;
        final allItems = _syrveController.menuItems;

        final isRtl =
            _languageController.currentLanguage.value ==
            LanguageController.arabic;

        List<MenuItem> filteredItems;
        if (selectedCategoryId == 'all') {
          filteredItems = allItems;
        } else {
          final selectedCategory = allCategories.firstWhereOrNull(
            (c) => c.id == selectedCategoryId,
          );
          filteredItems =
              selectedCategory?.items
                  ?.where((item) => item.isHidden != true)
                  .toList() ??
              [];
        }

        final categories = [
          MenuItemCategory(id: 'all', name: 'all'.tr),
          ...allCategories.where((c) => c.isHidden != true),
        ];

        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Obx(() {
                    final banners = _bannerController.banners;

                    if (_bannerController.isLoading.value) {
                      return Container(
                        height: 0.38.sh,
                        width: 1.sw,
                        color: Colors.grey[200],
                      );
                    }

                    if (banners.isNotEmpty) {
                      return SizedBox(
                        height: 0.38.sh,
                        width: 1.sw,
                        child: PageView.builder(
                          itemCount: banners.length,
                          itemBuilder: (context, index) {
                            final bannerUrl = banners[index].banner;

                            if (bannerUrl == null || bannerUrl.isEmpty) {
                              return Container(color: Colors.grey[200]);
                            }

                            return CachedNetworkImage(
                              imageUrl: bannerUrl,
                              fit: BoxFit.cover,
                              cacheManager: CacheConfig.optimizedCacheManager,
                              placeholder: (_, _) =>
                                  Container(color: Colors.grey[200]),
                              errorWidget: (_, _, _) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return Assets.banner.ad1.image(
                      height: 0.38.sh,
                      width: 1.sw,
                    );
                  }),
                  Positioned(
                    top: 0.36.sh - 100.h,
                    left: isRtl ? null : 0.04.sh,
                    right: isRtl ? 0.04.sh : null,
                    bottom: 0,
                    child: SizedBox(
                      width: 0.38.sh,
                      child: _syrveController.isLoadingMenu.value
                          ? const MenuShimmer()
                          : StaggeredGridView.countBuilder(
                              crossAxisCount: 3,
                              itemCount: filteredItems.length,
                              padding: EdgeInsets.all(16.w),
                              mainAxisSpacing: 20.h,
                              crossAxisSpacing: 20.w,
                              staggeredTileBuilder: (_) =>
                                  const StaggeredTile.fit(1),
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: filteredItems[index],
                                );
                              },
                            ),
                    ),
                  ),
                  Positioned(
                    top: 0.36.sh - 100.h,
                    left: isRtl ? 0.04.sh : null,
                    right: isRtl ? null : 0.04.sh,
                    bottom: 0,
                    child: SizedBox(
                      width: 180.w,
                      child: _syrveController.isLoadingMenu.value
                          ? const CategoryShimmer()
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              itemCount: categories.length,
                              separatorBuilder: (_, _) =>
                                  SizedBox(height: 12.h),
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                return CategoryWidget(
                                  category: category,
                                  isSelected: category.id == selectedCategoryId,
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryId = category.id ?? 'all';
                                    });
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const CartBottomBar(showHomeButton: true),
          ],
        );
      }),
    );
  }
}
