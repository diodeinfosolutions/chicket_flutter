import 'package:chicket/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/order_controller.dart';
import '../../gen/assets.gen.dart';
import '../../theme/colors.dart';
import '../menu/widgets/cart_bottom_bar.dart';

class MobScreen extends StatefulWidget {
  const MobScreen({super.key});

  @override
  State<MobScreen> createState() => _MobScreenState();
}

class _MobScreenState extends State<MobScreen> {
  String _phoneNumber = '';
  final OrderController _orderController = Get.find<OrderController>();

  static final double _keyWidth = 116.w;
  static final double _keyHeight = 116.h;
  static final double _keySpacing = 24.w;
  double get _numpadWidth => (_keyWidth * 3) + (_keySpacing * 2);

  String get _maskedNumber {
    if (_phoneNumber.isEmpty) return '';
    final buffer = StringBuffer();
    for (int i = 0; i < _phoneNumber.length; i++) {
      if (i % 2 == 1) {
        buffer.write('X');
      } else {
        buffer.write(_phoneNumber[i]);
      }
    }
    return buffer.toString();
  }

  void _onNumberPressed(String number) {
    if (_phoneNumber.length < 8) {
      setState(() {
        _phoneNumber += number;
      });
    }
  }

  void _onBackspacePressed() {
    if (_phoneNumber.isNotEmpty) {
      setState(() {
        _phoneNumber = _phoneNumber.substring(0, _phoneNumber.length - 1);
      });
    }
  }

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
                  SizedBox(height: 48.h),
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: AppColors.GREEN.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Assets.svg.receipt.svg(
                        width: 64.w,
                        height: 64.w,
                        colorFilter: const ColorFilter.mode(
                          AppColors.GREEN,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'receive_e_receipt'.tr,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 51.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.BLACK,
                    ),
                  ),
                  SizedBox(height: 13.h),
                  Text(
                    'e_receipt_sent_via'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 29.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.GREY,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.svg.leaf.svg(height: 22.w, width: 22.w),
                      SizedBox(width: 6.w),
                      Text(
                        'thanks_paperless'.tr,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.GREEN,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+973',
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.BLACK,
                        ),
                      ),
                      SizedBox(width: 13.w),
                      Container(
                        width: 288.w,
                        height: 74.h,
                        decoration: BoxDecoration(
                          color: const Color(0x4DF7BE26),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: AppColors.YELLOW, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            _maskedNumber.isEmpty
                                ? ''
                                : _maskedNumber.split('').join(' '),
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.BLACK,
                              letterSpacing: 1.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  _buildNumpad(),
                  SizedBox(height: 26.h),
                  SizedBox(
                    width: _numpadWidth,
                    child: ElevatedButton(
                      onPressed: _phoneNumber.length == 8
                          ? () {
                              _orderController.setCustomerPhone(
                                '+973$_phoneNumber',
                              );
                              Get.toNamed(Routes.selectPayment);
                            }
                          : null,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.BROWN,
                        foregroundColor: AppColors.YELLOW,
                        disabledBackgroundColor: AppColors.BROWN.withValues(
                          alpha: 0.5,
                        ),
                        disabledForegroundColor: AppColors.YELLOW.withValues(
                          alpha: 0.5,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                      ),
                      child: Text(
                        'continue_to_payment'.tr,
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: _numpadWidth,
                    child: OutlinedButton(
                      onPressed: () => Get.toNamed(Routes.cart),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.WHITE,
                        foregroundColor: AppColors.BROWN,
                        side: const BorderSide(
                          color: AppColors.BROWN,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                      ),
                      child: Text(
                        'return_to_cart'.tr,
                        style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
            const CartBottomBar(hideButtons: true, showMenuButton: true),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumpadKey('1'),
            SizedBox(width: _keySpacing),
            _buildNumpadKey('2'),
            SizedBox(width: _keySpacing),
            _buildNumpadKey('3'),
          ],
        ),
        SizedBox(height: 13.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumpadKey('4'),
            SizedBox(width: _keySpacing),
            _buildNumpadKey('5'),
            SizedBox(width: _keySpacing),
            _buildNumpadKey('6'),
          ],
        ),
        SizedBox(height: 13.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumpadKey('7'),
            SizedBox(width: _keySpacing),
            _buildNumpadKey('8'),
            SizedBox(width: _keySpacing),
            _buildNumpadKey('9'),
          ],
        ),
        SizedBox(height: 13.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: _keyWidth),
            SizedBox(width: _keySpacing),
            _buildNumpadKey('0'),
            SizedBox(width: _keySpacing),
            _buildBackspaceKey(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumpadKey(String number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: _keyWidth,
        height: _keyHeight,
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.GREY_LIGHT, width: 1.3),
        ),
        child: Center(
          child: Text(
            number,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 42.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.BLACK,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return GestureDetector(
      onTap: _onBackspacePressed,
      child: Container(
        width: _keyWidth,
        height: _keyHeight,
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.GREY_LIGHT, width: 1.3),
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 42.w,
            color: AppColors.BLACK,
          ),
        ),
      ),
    );
  }
}
