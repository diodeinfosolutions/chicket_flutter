import 'package:chicket/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart' as svg;
import 'package:get/get.dart';

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

                  SizedBox(height: 48.h),
                  _buildPaymentOptionsGrid(),
                ],
              ),
            ),
            CartBottomBar(
              hideButtons: true,
              showMenuButton: true,
              customActionButton: GestureDetector(
                onTap: _selectedPaymentType != null
                    ? () {
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
        .where((p) {
          final name = p.name.toLowerCase();

          return name.contains('debit card') ||
              name.contains('credit card') ||
              name.contains('benefit') ||
              name.contains('benifit');
        })
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

    final List<Widget> rows = [];
    for (int i = 0; i < paymentTypes.length; i += 2) {
      final rowItems = <Widget>[];
      rowItems.add(_buildPaymentOption(paymentTypes[i]));
      if (i + 1 < paymentTypes.length) {
        rowItems.add(SizedBox(width: 40.w));
        rowItems.add(_buildPaymentOption(paymentTypes[i + 1]));
      }
      rows.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: rowItems),
      );
      if (i + 2 < paymentTypes.length) {
        rows.add(SizedBox(height: 40.h));
      }
    }

    return Column(children: rows);
  }

  Widget _buildPaymentOption(PaymentType paymentType) {
    final isSelected = _selectedPaymentType?.id == paymentType.id;
    final image = _getPaymentImage(paymentType);

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
            (image ??
                Icon(
                  Icons.payment_outlined,
                  size: 48.w,
                  color: isSelected ? AppColors.GREEN : AppColors.GREY,
                )),
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

  Widget? _getPaymentImage(PaymentType paymentType) {
    final kind = paymentType.paymentTypeKind?.toLowerCase();
    final name = paymentType.name.toLowerCase();

    if (name.contains('benefit') || name.contains('benifit')) {
      return svg.SvgPicture.asset(
        'assets/svg/benefit.svg',
        width: 64.w,
        height: 48.h,
        colorFilter: ColorFilter.mode(
          _selectedPaymentType?.id == paymentType.id
              ? AppColors.GREEN
              : AppColors.GREY,
          BlendMode.srcIn,
        ),
      );
    }

    if (name.contains('card') ||
        name.contains('visa') ||
        name.contains('mastercard')) {
      return Assets.png.cc.image(
        width: 64.w,
        height: 48.h,
        fit: BoxFit.contain,
        color: _selectedPaymentType?.id == paymentType.id
            ? AppColors.GREEN
            : AppColors.GREY,
      );
    }

    switch (kind) {
      case 'cash':
        return Assets.png.cash.image(
          width: 64.w,
          height: 48.h,
          fit: BoxFit.contain,
          color: _selectedPaymentType?.id == paymentType.id
              ? AppColors.GREEN
              : AppColors.GREY,
        );
      case 'card':
      case 'creditcard':
      case 'visa':
      case 'mastercard':
        return Assets.png.cc.image(
          width: 64.w,
          height: 48.h,
          fit: BoxFit.contain,
          color: _selectedPaymentType?.id == paymentType.id
              ? AppColors.GREEN
              : AppColors.GREY,
        );
      case 'voucher':
      case 'coupon':
        return Assets.png.giftVoucher.image(
          width: 64.w,
          height: 48.h,
          fit: BoxFit.contain,
          color: _selectedPaymentType?.id == paymentType.id
              ? AppColors.GREEN
              : AppColors.GREY,
        );
      case 'external':
      case 'iikocard':
      default:
        return null;
    }
  }
}
