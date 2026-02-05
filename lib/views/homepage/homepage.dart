import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';

import '../../controllers/syrve_controller.dart';
import 'widgets/footer_section.dart';
import 'widgets/header_section.dart';
import 'widgets/language_selector_row.dart';
import 'widgets/order_option_row.dart';
import 'widgets/order_text_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GifController _gifController;
  final SyrveController _syrveController = Get.find<SyrveController>();

  @override
  void initState() {
    super.initState();
    _gifController = GifController();
    _preloadData();
  }

  void _preloadData() {
    if (!_syrveController.isDataLoaded) {
      _syrveController.initialize();
    }
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      const Spacer(flex: 2),
                      OrderTextSection(isTabletPortrait: isTabletPortrait),
                      const Spacer(flex: 2),
                      OrderOptionsRow(isTabletPortrait: isTabletPortrait),
                      const Spacer(),
                      LanguageSelectorRow(isTabletPortrait: isTabletPortrait),
                      const Spacer(flex: 2),
                      FooterSection(isTabletPortrait: isTabletPortrait),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
