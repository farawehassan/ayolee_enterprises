import 'dart:ui';
import 'package:flutter/cupertino.dart';

/// A class for setting themes for color gradients
class ColorGradients {

  const ColorGradients();

  static const Color loginGradientStart = const Color(0xFF3282b8);
  static const Color loginGradientEnd = const Color(0xFF0f4c75);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}