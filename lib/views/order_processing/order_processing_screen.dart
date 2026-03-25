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
import '../../controllers/apex_ecr_controller.dart';
import '../../utils/en_locale.dart';
import '../../utils/log_local.dart';

/// Screen that handles the end-to-end order processing flow.
/// Orchestrates payment processing (EFTPOS/Cash) and Syrve order creation,
/// while providing visual feedback to the user via animations.
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

    // Animation for the "On the Way" icon movement
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

    _processOrder();
  }

  /// Main entry point for the order flow.
  /// Decides between Card (External ECR) and Cash flows.
  Future<void> _processOrder() async {
    final paymentType = _orderController.selectedPaymentType.value;
    final isCard =
        paymentType?.paymentTypeKind == 'Card' ||
        paymentType?.paymentTypeKind == 'External';

    if (isCard) {
      final ecrController = Get.find<ApexEcrController>();
      final amount = _orderController.cartTotal;
      
      // Multi-step transaction: 1. Pay on Terminal
      final invoiceNumber = (DateTime.now().millisecondsSinceEpoch % 1000000)
          .toString()
          .padLeft(6, '0');

      final response = await ecrController.processSale(amount, invoiceNumber);

      if ((response.webResponseStatus.toLowerCase() == '0' || response.webResponseStatus.toLowerCase() == 'success') && response.posRespStatus == 1) {
        // 2. If payment success, create record in Syrve
        logLocal('Payment success for invoice $invoiceNumber, creating Syrve order.');
        await _createOrder();
      } else {
        logLocal('Payment failed for invoice $invoiceNumber: ${ecrController.getErrorMessage(response)}');
        if (mounted) {
          setState(() {
            _errorMessage = ecrController.getErrorMessage(response);
          });
        }
      }
    } else {
      // Cash payment bypasses terminal processing
      await _createOrder();
    }
  }

  /// Communicates with Syrve API to create the final order.
  Future<void> _createOrder() async {
    try {
      final orderItems = _buildOrderItems();
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

      final orderServiceType = _orderController.orderServiceType;
      final apiOrderType = orderServiceType != null
          ? _syrveController.getOrderTypeByServiceType(orderServiceType)
          : null;

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
        logLocal('Syrve order created successfully.');
        _animationController.forward();
        _animationController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Get.toNamed(Routes.confirmed);
          }
        });
      } else {
        final err = _syrveController.orderError.value ?? 'Failed to create order';
        logLocal('Syrve order creation failed: $err');
        setState(() {
          _errorMessage = err;
        });
      }
    } catch (e) {
      logLocal('OrderProcessingScreen _createOrder exception: $e');
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  /// Maps internal cart items to the Syrve [OrderItem] structure.
  List<OrderItem> _buildOrderItems() {
    final items = <OrderItem>[];

    for (final cartItem in _orderController.cart) {
      final productId = cartItem['productId'] as String;
      final qty = cartItem['qty'] as int;
      final modifiersMap =
          cartItem['modifiers'] as Map<String, List<Map<String, dynamic>>>?;

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
                    child: _errorMessage != null
                        ? _buildErrorContent(isTabletPortrait)
                        : _buildProcessingContent(isTabletPortrait),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the premium error interface with animated pulsing visuals.
  Widget _buildErrorContent(bool isTabletPortrait) {
    return Column(
      children: [
        const Spacer(),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: 1.2),
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          builder: (context, scale, child) {
            return Container(
              width: 180.w * scale,
              height: 180.w * scale,
              decoration: BoxDecoration(
                color: AppColors.RED.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 140.w,
                  height: 140.w,
                  decoration: const BoxDecoration(
                    color: AppColors.RED,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.priority_high_rounded,
                    color: Colors.white,
                    size: 80.w,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 48.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'order_failed'.tr.toUpperCase(),
            style: TextStyle(
              fontFamily: "Oswald",
              fontSize: isTabletPortrait ? 64.sp : 84.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.RED,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.15.sw),
          child: Text(
            _errorMessage!,
            style: TextStyle(
              fontFamily: "Oswald",
              fontSize: isTabletPortrait ? 24.sp : 32.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.BLACK,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        FittedBox(
          child: GestureDetector(
            onTap: () {
              _orderController.cart.clear();
              Get.offAllNamed(Routes.home);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 0.2.sw),
              padding: EdgeInsets.symmetric(vertical: 24.h,horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.BROWN,
                borderRadius: BorderRadius.circular(50.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.BROWN.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_rounded, color: AppColors.YELLOW, size: 36.sp),
                  SizedBox(width: 16.w),
                  Text(
                    'back_to_home'.tr.toUpperCase(),
                    style: TextStyle(
                      fontFamily: "Oswald",
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.YELLOW,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 48.h),
        EnLocale(
          child: FooterSection(
            isTabletPortrait: isTabletPortrait,
          ),
        ),
      ],
    );
  }

  /// Builds the processing/loading interface with the animated "On the Way" delivery icon.
  Widget _buildProcessingContent(bool isTabletPortrait) {
    return Column(
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
        EnLocale(
          child: FooterSection(
            isTabletPortrait: isTabletPortrait,
          ),
        ),
      ],
    );
  }
}
