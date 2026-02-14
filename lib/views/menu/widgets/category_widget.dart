import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../api/models/menu_models.dart';
import '../../../utils/cache_config.dart';

class CategoryWidget extends StatelessWidget {
  final MenuItemCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryWidget({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        category.buttonImageUrl != null && category.buttonImageUrl!.isNotEmpty;
    final categoryName = category.name ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 56.w,
                  height: 56.w,
                  child: hasImage
                      ? CachedNetworkImage(
                          imageUrl: category.buttonImageUrl!,
                          width: 56.w,
                          height: 56.w,
                          fit: BoxFit.contain,
                          cacheManager: CacheConfig.optimizedCacheManager,
                          placeholder: (context, url) => Icon(
                            Icons.restaurant_menu_outlined,
                            size: 56.w,
                            color: const Color(0xFF283034),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.restaurant_menu_outlined,
                            size: 56.w,
                            color: const Color(0xFF283034),
                          ),
                        )
                      : Icon(
                          Icons.restaurant_menu_outlined,
                          size: 56.w,
                          color: isSelected
                              ? const Color(0xFFDD2229)
                              : const Color(0xFF283034),
                        ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 40.h,
                  child: Text(
                    categoryName.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFFDD2229)
                          : const Color(0xFF283034),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDD2229),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
