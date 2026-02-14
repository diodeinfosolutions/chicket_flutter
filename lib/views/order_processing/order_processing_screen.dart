import 'package:chicket/views/homepage/widgets/footer_section.dart';
import 'package:chicket/views/homepage/widgets/header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';

import '../../controllers/order_controller.dart';
import '../../controllers/syrve_controller.dart';
import '../../api/models/delivery_models.dart';
import '../../gen/assets.gen.dart';
import '../../routes.dart';
import '../../theme/colors.dart';

class OrderProcessingScreen extends StatefulWidget {
  const OrderProcessingScreen({super.key});

  @override
  State<OrderProcessingScreen> createState() => _OrderProcessingScreenState();
}

class _OrderProcessingScreenState extends State<OrderProcessingScreen>
    with SingleTickerProviderStateMixin {
  late final GifController _gifController;
  late final AnimationController _animationController;
  late final Animation<double> _positionAnimation;

  final OrderController _orderController = Get.find<OrderController>();
  final SyrveController _syrveController = Get.find<SyrveController>();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _gifController = GifController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _positionAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -2.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.decelerate)),
        weight: 20,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 65),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 2.0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 15,
      ),
    ]).animate(_animationController);

    // Start order creation
    _createOrder();
  }

  Future<void> _createOrder() async {
    try {
      // Build order items from cart
      final orderItems = _buildOrderItems();

      // Get payment info
      final paymentType = _orderController.selectedPaymentType.value;
      List<OrderPayment>? payments;

      if (paymentType != null) {
        payments = [
          OrderPayment(
            paymentTypeKind: paymentType.paymentTypeKind ?? 'Cash',
            paymentTypeId: paymentType.id,
            sum: _orderController.cartTotal,
            isProcessedExternally:
                paymentType.paymentTypeKind == 'Card' ||
                paymentType.paymentTypeKind == 'External',
          ),
        ];
      }

      // Find matching API order type
      final orderServiceType = _orderController.orderServiceType;
      final apiOrderType = orderServiceType != null
          ? _syrveController.getOrderTypeByServiceType(orderServiceType)
          : null;

      // Create order via API
      final success = await _syrveController.createOrder(
        items: orderItems,
        orderTypeId: apiOrderType?.id,
        orderServiceType: orderServiceType,
        phone: _orderController.customerPhone.value.isNotEmpty
            ? _orderController.customerPhone.value
            : null,
        payments: payments,
        guests: Guests(count: 1),
      );

      if (success) {
        // Start animation after successful order creation
        _animationController.forward();
        _animationController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Get.toNamed(Routes.confirmed);
          }
        });
      } else {
        setState(() {
          _errorMessage =
              _syrveController.orderError.value ?? 'Failed to create order';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  List<OrderItem> _buildOrderItems() {
    final items = <OrderItem>[];

    for (final cartItem in _orderController.cart) {
      final productId = cartItem['productId'] as String;
      final qty = cartItem['qty'] as int;
      final modifiersMap =
          cartItem['modifiers'] as Map<String, List<Map<String, dynamic>>>?;

      // Build modifiers list
      List<OrderItemModifier>? modifiers;
      if (modifiersMap != null && modifiersMap.isNotEmpty) {
        modifiers = [];
        for (final groupMods in modifiersMap.values) {
          for (final mod in groupMods) {
            modifiers.add(
              OrderItemModifier(productId: mod['id'] as String, amount: 1),
            );
          }
        }
      }

      items.add(
        OrderItem(
          productId: productId,
          type: 'Product',
          amount: qty,
          modifiers: modifiers,
        ),
      );
    }

    return items;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error screen if order creation failed
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80.w, color: Colors.red),
              SizedBox(height: 24.h),
              Text(
                'order_failed'.tr,
                style: TextStyle(
                  fontFamily: "Oswald",
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.BLACK,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48.w),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 20.sp,
                    color: AppColors.GREY,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(Routes.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.BROWN,
                  foregroundColor: AppColors.YELLOW,
                  padding: EdgeInsets.symmetric(
                    horizontal: 48.w,
                    vertical: 16.h,
                  ),
                ),
                child: Text(
                  'back_to_home'.tr,
                  style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;
            final aspectRatio = screenWidth / screenHeight;

            final isTabletPortrait = aspectRatio < 0.7 && screenWidth > 600;
            final headerHeightFactor = isTabletPortrait ? 0.32 : 0.44;

            return SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Column(
                children: [
                  HeaderSection(
                    gifController: _gifController,
                    heightFactor: headerHeightFactor,
                    isTabletPortrait: isTabletPortrait,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                            color: AppColors.GREEN.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: AnimatedBuilder(
                              animation: _positionAnimation,
                              builder: (context, child) {
                                final position = _positionAnimation.value;

                                final isMoving = position.abs() > 0.1;
                                final scaleX = isMoving ? 1.3 : 1.0;
                                final scaleY = isMoving ? 0.85 : 1.0;

                                return Transform.translate(
                                  offset: Offset(position * 100.w, 0),
                                  child: Transform.scale(
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                    child: child,
                                  ),
                                );
                              },
                              child: Center(
                                child: Assets.svg.onTheWay.svg(
                                  width: 100.w,
                                  height: 100.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 48.h),
                        Text(
                          'order_on_its_way'.tr,
                          style: TextStyle(
                            fontFamily: "Oswald",
                            fontSize: 52.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.BLACK,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(),
                        FooterSection(isTabletPortrait: isTabletPortrait),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
