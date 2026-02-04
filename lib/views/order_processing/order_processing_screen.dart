import 'package:chicket/views/homepage/widgets/footer_section.dart';
import 'package:chicket/views/homepage/widgets/header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';

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

    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.toNamed(Routes.confirmed);
      }
    });
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
                          'ORDER IS ON ITS WAY TO\nTHE KITCHEN',
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
