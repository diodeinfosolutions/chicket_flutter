import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../gen/assets.gen.dart';
import '../../models/menu_model.dart';
import 'widgets/cart_bottom_bar.dart';
import 'widgets/category_widget.dart';
import 'widgets/product_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategoryId = 'all';

  List<Product> get filteredProducts => selectedCategoryId == 'all'
      ? products
      : products.where((p) => p.categoryId == selectedCategoryId).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Assets.banner.ad1.image(
                  height: 0.38.sh,
                  width: 1.sw,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.36.sh - 100.h, left: 0.04.sh),
                  child: SizedBox(
                    width: 0.52.sh,
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      itemCount: filteredProducts.length,
                      padding: EdgeInsets.all(16.w),
                      mainAxisSpacing: 20.h,
                      crossAxisSpacing: 20.w,
                      staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        return ProductCard(product: filteredProducts[index]);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0.36.sh - 100.h,
                  right: 0.04.sh,
                  bottom: 0,
                  child: SizedBox(
                    width: 180.w,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      itemCount: allCategories.length,
                      separatorBuilder: (_, _) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final category = allCategories[index];
                        return CategoryWidget(
                          category: category,
                          isSelected: category.id == selectedCategoryId,
                          onTap: () {
                            setState(() {
                              selectedCategoryId = category.id;
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
          const CartBottomBar(),
        ],
      ),
    );
  }
}
