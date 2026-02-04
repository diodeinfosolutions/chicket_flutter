import 'package:flutter/material.dart';

ColorFilter getColorFilter(
  Color color, [
  BlendMode blendMode = BlendMode.srcIn,
]) {
  return ColorFilter.mode(color, blendMode);
}
