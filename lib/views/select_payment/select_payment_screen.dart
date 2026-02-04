import 'package:chicket/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../gen/assets.gen.dart';
import '../../theme/colors.dart';
import '../menu/widgets/cart_bottom_bar.dart';

class SelectPaymentScreen extends StatefulWidget {
  const SelectPaymentScreen({super.key});

  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  int? _selectedPaymentIndex;

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
                    'SELECT PAYMENT OPTIONS',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 52.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.BLACK,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'PLEASE SCAN THE QR CODE TO MAKE PAYMENT',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.GREY,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  QrImageView(
                    data: 'https://chicket.com/pay/order123',
                    version: QrVersions.auto,
                    size: 280.w,
                    backgroundColor: AppColors.WHITE,
                  ),
                  SizedBox(height: 80.h),
                  Text(
                    'OTHERS',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.GREY,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _buildPaymentOptionsGrid(),
                ],
              ),
            ),
            CartBottomBar(
              hideButtons: true,
              customActionButton: GestureDetector(
                onTap: _selectedPaymentIndex != null
                    ? () => Get.toNamed(Routes.orderProcessing)
                    : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedPaymentIndex != null
                        ? AppColors.BROWN
                        : AppColors.GREY_LIGHT,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: _selectedPaymentIndex != null
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
    final paymentOptions = [
      _PaymentOption(image: Assets.png.cc, label: 'CREDIT/DEBIT CARD'),
      _PaymentOption(image: Assets.png.wafaa, label: 'WAFAA+ VOUCHER'),
      _PaymentOption(image: Assets.png.giftVoucher, label: 'GIFT VOUCHER'),
      _PaymentOption(image: Assets.png.cash, label: 'PAY CASH AT COUNTER'),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPaymentOption(paymentOptions[0], 0),
            SizedBox(width: 24.w),
            _buildPaymentOption(paymentOptions[1], 1),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPaymentOption(paymentOptions[2], 2),
            SizedBox(width: 24.w),
            _buildPaymentOption(paymentOptions[3], 3),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption(_PaymentOption option, int index) {
    final isSelected = _selectedPaymentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentIndex = index;
        });
      },
      child: Container(
        width: 280.w,
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.GREEN : AppColors.GREY_LIGHT,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            option.image.image(width: 96.w, height: 72.h, fit: BoxFit.contain),
            SizedBox(height: 16.h),
            Text(
              option.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.GREEN : AppColors.GREY,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption {
  final AssetGenImage image;
  final String label;

  _PaymentOption({required this.image, required this.label});
}
