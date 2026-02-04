// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsBannerGen {
  const $AssetsBannerGen();

  /// File path: assets/banner/AD1.png
  AssetGenImage get ad1 => const AssetGenImage('assets/banner/AD1.png');

  /// File path: assets/banner/broasted.svg
  SvgGenImage get broasted => const SvgGenImage('assets/banner/broasted.svg');

  /// File path: assets/banner/burger.svg
  SvgGenImage get burger => const SvgGenImage('assets/banner/burger.svg');

  /// File path: assets/banner/combo_meal.svg
  SvgGenImage get comboMeal =>
      const SvgGenImage('assets/banner/combo_meal.svg');

  /// File path: assets/banner/falafel.svg
  SvgGenImage get falafel => const SvgGenImage('assets/banner/falafel.svg');

  /// File path: assets/banner/food1.png
  AssetGenImage get food1 => const AssetGenImage('assets/banner/food1.png');

  /// File path: assets/banner/food2.png
  AssetGenImage get food2 => const AssetGenImage('assets/banner/food2.png');

  /// File path: assets/banner/nugget.svg
  SvgGenImage get nugget => const SvgGenImage('assets/banner/nugget.svg');

  /// File path: assets/banner/sandwich.svg
  SvgGenImage get sandwich => const SvgGenImage('assets/banner/sandwich.svg');

  /// List of all assets
  List<dynamic> get values => [
    ad1,
    broasted,
    burger,
    comboMeal,
    falafel,
    food1,
    food2,
    nugget,
    sandwich,
  ];
}

class $AssetsGifGen {
  const $AssetsGifGen();

  /// File path: assets/gif/chicket.gif
  AssetGenImage get chicket => const AssetGenImage('assets/gif/chicket.gif');

  /// List of all assets
  List<AssetGenImage> get values => [chicket];
}

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/cash.png
  AssetGenImage get cash => const AssetGenImage('assets/png/cash.png');

  /// File path: assets/png/cc.png
  AssetGenImage get cc => const AssetGenImage('assets/png/cc.png');

  /// File path: assets/png/gift_voucher.png
  AssetGenImage get giftVoucher =>
      const AssetGenImage('assets/png/gift_voucher.png');

  /// File path: assets/png/wafaa.png
  AssetGenImage get wafaa => const AssetGenImage('assets/png/wafaa.png');

  /// List of all assets
  List<AssetGenImage> get values => [cash, cc, giftVoucher, wafaa];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/clear_cart.svg
  SvgGenImage get clearCart => const SvgGenImage('assets/svg/clear_cart.svg');

  /// File path: assets/svg/delete.svg
  SvgGenImage get delete => const SvgGenImage('assets/svg/delete.svg');

  /// File path: assets/svg/dinein.svg
  SvgGenImage get dinein => const SvgGenImage('assets/svg/dinein.svg');

  /// File path: assets/svg/leaf.svg
  SvgGenImage get leaf => const SvgGenImage('assets/svg/leaf.svg');

  /// File path: assets/svg/non.svg
  SvgGenImage get non => const SvgGenImage('assets/svg/non.svg');

  /// File path: assets/svg/on_the_way.svg
  SvgGenImage get onTheWay => const SvgGenImage('assets/svg/on_the_way.svg');

  /// File path: assets/svg/order_confirmed.svg
  SvgGenImage get orderConfirmed =>
      const SvgGenImage('assets/svg/order_confirmed.svg');

  /// File path: assets/svg/receipt.svg
  SvgGenImage get receipt => const SvgGenImage('assets/svg/receipt.svg');

  /// File path: assets/svg/repeat.svg
  SvgGenImage get repeat => const SvgGenImage('assets/svg/repeat.svg');

  /// File path: assets/svg/takeaway.svg
  SvgGenImage get takeaway => const SvgGenImage('assets/svg/takeaway.svg');

  /// File path: assets/svg/veg.svg
  SvgGenImage get veg => const SvgGenImage('assets/svg/veg.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    clearCart,
    delete,
    dinein,
    leaf,
    non,
    onTheWay,
    orderConfirmed,
    receipt,
    repeat,
    takeaway,
    veg,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsBannerGen banner = $AssetsBannerGen();
  static const $AssetsGifGen gif = $AssetsGifGen();
  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
