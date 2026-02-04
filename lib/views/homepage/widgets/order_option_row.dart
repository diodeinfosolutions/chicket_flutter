import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/order_controller.dart';
import '../../../gen/assets.gen.dart';
import 'order_option_button.dart';

class OrderOptionsRow extends StatelessWidget {
  final bool isTabletPortrait;

  const OrderOptionsRow({super.key, this.isTabletPortrait = false});

  @override
  Widget build(BuildContext context) {
    final orderController = Get.find<OrderController>();
    final iconSize = isTabletPortrait ? 0.05.sh : 0.072.sh;
    final dividerHeight = isTabletPortrait ? 0.055.sh : 0.08.sh;
    final horizontalMargin = isTabletPortrait ? 0.035.sw : 0.052.sw;

    return IntrinsicHeight(
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OrderOptionButton(
              isSelected:
                  orderController.selectedType.value == OrderType.dineIn,
              onTap: () => orderController.selectOrderType(OrderType.dineIn),
              isTabletPortrait: isTabletPortrait,
              label: 'dine_in'.tr,
              child: Assets.svg.dinein.svg(height: iconSize, width: iconSize),
            ),
            Container(
              width: 2.w,
              height: dividerHeight,
              margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
              color: const Color(0xFFD9D9D9),
            ),
            OrderOptionButton(
              isSelected:
                  orderController.selectedType.value == OrderType.takeaway,
              onTap: () => orderController.selectOrderType(OrderType.takeaway),
              isTabletPortrait: isTabletPortrait,
              label: 'takeaway'.tr,
              child: Assets.svg.takeaway.svg(height: iconSize, width: iconSize),
            ),
          ],
        ),
      ),
    );
  }
}
