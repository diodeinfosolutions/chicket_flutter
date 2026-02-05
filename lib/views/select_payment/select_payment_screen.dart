import 'package:chicket/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// TODO: Re-enable when payment QR is available
// import 'package:qr_flutter/qr_flutter.dart';

import '../../controllers/order_controller.dart';
import '../../controllers/syrve_controller.dart';
import '../../api/models/payment_models.dart';
import '../../gen/assets.gen.dart';
import '../../theme/colors.dart';
import '../menu/widgets/cart_bottom_bar.dart';

class SelectPaymentScreen extends StatefulWidget {
  const SelectPaymentScreen({super.key});

  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  PaymentType? _selectedPaymentType;
  final SyrveController _syrveController = Get.find<SyrveController>();
  final OrderController _orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h),
                  Text(
                    'select_payment_options'.tr,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 52.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.BLACK,
                    ),
                  ),
                  // TODO: Re-enable when payment QR is available
                  // SizedBox(height: 24.h),
                  // Text(
                  //   'scan_qr_to_pay'.tr,
                  //   style: TextStyle(
                  //     fontFamily: 'Oswald',
                  //     fontSize: 24.sp,
                  //     fontWeight: FontWeight.w500,
                  //     color: AppColors.GREY,
                  //   ),
                  // ),
                  // SizedBox(height: 48.h),
                  // QrImageView(
                  //   data: 'https://chicket.com/pay/order123',
                  //   version: QrVersions.auto,
                  //   size: 280.w,
                  //   backgroundColor: AppColors.WHITE,
                  // ),
                  // SizedBox(height: 80.h),
                  // Text(
                  //   'others'.tr,
                  //   style: TextStyle(
                  //     fontFamily: 'Oswald',
                  //     fontSize: 28.sp,
                  //     fontWeight: FontWeight.w500,
                  //     color: AppColors.GREY,
                  //   ),
                  // ),
                  SizedBox(height: 48.h),
                  _buildPaymentOptionsGrid(),
                ],
              ),
            ),
            CartBottomBar(
              hideButtons: true,
              customActionButton: GestureDetector(
                onTap: _selectedPaymentType != null
                    ? () {
                        // Store selected payment type
                        _orderController.setPaymentType(_selectedPaymentType!);
                        Get.toNamed(Routes.orderProcessing);
                      }
                    : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedPaymentType != null
                        ? AppColors.BROWN
                        : AppColors.GREY_LIGHT,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'continue_btn'.tr,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: _selectedPaymentType != null
                          ? AppColors.YELLOW
                          : AppColors.GREY,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptionsGrid() {
    final paymentTypes = _syrveController.paymentTypes
        .where((p) => p.isDeleted != true)
        .toList();

    if (paymentTypes.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          'no_payment_methods'.tr,
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 20.sp,
            color: AppColors.GREY,
          ),
        ),
      );
    }

    // Create rows of 2 items each (2x2 grid)
    final List<Widget> rows = [];
    for (int i = 0; i < paymentTypes.length; i += 2) {
      final rowItems = <Widget>[];
      rowItems.add(_buildPaymentOption(paymentTypes[i]));
      if (i + 1 < paymentTypes.length) {
        rowItems.add(SizedBox(width: 40.w));
        rowItems.add(_buildPaymentOption(paymentTypes[i + 1]));
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowItems,
      ));
      if (i + 2 < paymentTypes.length) {
        rows.add(SizedBox(height: 40.h));
      }
    }

    return Column(children: rows);
  }

  Widget _buildPaymentOption(PaymentType paymentType) {
    final isSelected = _selectedPaymentType?.id == paymentType.id;
    final image = _getPaymentImage(paymentType.paymentTypeKind);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentType = paymentType;
        });
      },
      child: Container(
        width: 200.w,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.GREEN : AppColors.GREY_LIGHT,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image != null
                ? image.image(
                    width: 64.w,
                    height: 48.h,
                    fit: BoxFit.contain,
                    color: isSelected ? AppColors.GREEN : AppColors.GREY,
                  )
                : Icon(
                    Icons.payment_outlined,
                    size: 48.w,
                    color: isSelected ? AppColors.GREEN : AppColors.GREY,
                  ),
            SizedBox(height: 12.h),
            Text(
              paymentType.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.GREEN : AppColors.GREY,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AssetGenImage? _getPaymentImage(String? paymentTypeKind) {
    // TODO: Update with correct payment icons when available
    switch (paymentTypeKind?.toLowerCase()) {
      case 'cash':
        return Assets.png.cash;
      case 'card':
      case 'creditcard':
      case 'visa':
      case 'mastercard':
        return Assets.png.cc;
      case 'voucher':
      case 'coupon':
        return Assets.png.giftVoucher;
      case 'external':
      case 'iikocard':
      default:
        return null;
    }
  }
}
