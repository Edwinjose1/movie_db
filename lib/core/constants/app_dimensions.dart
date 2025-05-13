// lib/core/constants/app_dimensions.dart
import 'package:flutter/material.dart';

class AppDimensions {
  // Base sizes
  static const double kPaddingXS = 4.0;
  static const double kPaddingS = 8.0;
  static const double kPaddingM = 16.0;
  static const double kPaddingL = 24.0;
  static const double kPaddingXL = 32.0;
  
  // Border radius
  static const double kRadiusS = 4.0;
  static const double kRadiusM = 8.0;
  static const double kRadiusL = 16.0;
  
  // Font sizes
  static const double kTextXS = 10.0;
  static const double kTextS = 12.0;
  static const double kTextM = 14.0;
  static const double kTextL = 16.0;
  static const double kTextXL = 18.0;
  static const double kHeadingS = 20.0;
  static const double kHeadingM = 24.0;
  static const double kHeadingL = 28.0;
  
  // Standard card dimensions
  static const double kCardWidthS = 120.0;
  static const double kCardWidthM = 140.0;
  static const double kCardWidthL = 160.0;
  
  static const double kCardHeightS = 180.0;
  static const double kCardHeightM = 200.0;
  static const double kCardHeightL = 220.0;
  
  // Dynamic sizing helpers
  static double getResponsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }
  
  static double getResponsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }
  
  // Screen size breakpoints
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
  
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }
  
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }
  
  // Responsive text sizes based on screen width
  static double responsiveTextSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return baseSize * 0.8;
    if (width < 600) return baseSize;
    if (width < 900) return baseSize * 1.1;
    return baseSize * 1.2;
  }
  
  // Responsive font sizes
  static double textXS(BuildContext context) => responsiveTextSize(context, kTextXS);
  static double textS(BuildContext context) => responsiveTextSize(context, kTextS);
  static double textM(BuildContext context) => responsiveTextSize(context, kTextM);
  static double textL(BuildContext context) => responsiveTextSize(context, kTextL);
  static double textXL(BuildContext context) => responsiveTextSize(context, kTextXL);
  static double headingS(BuildContext context) => responsiveTextSize(context, kHeadingS);
  static double headingM(BuildContext context) => responsiveTextSize(context, kHeadingM);
  static double headingL(BuildContext context) => responsiveTextSize(context, kHeadingL);
  
  // Movie card dimensions
  static double movieCardWidth(BuildContext context) {
    if (isSmallScreen(context)) return kCardWidthS;
    if (isMediumScreen(context)) return kCardWidthM;
    return kCardWidthL;
  }
  
  static double movieCardHeight(BuildContext context) {
    if (isSmallScreen(context)) return kCardHeightS;
    if (isMediumScreen(context)) return kCardHeightM;
    return kCardHeightL;
  }
  
  // Section padding
  static double sectionPadding(BuildContext context) {
    if (isSmallScreen(context)) return kPaddingM;
    if (isMediumScreen(context)) return kPaddingL;
    return kPaddingXL;
  }
}