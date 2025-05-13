// lib/core/utils/responsive_size.dart
import 'package:flutter/material.dart';

class ResponsiveSize {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  
  // For horizontal lists
  static double movieCardWidth(BuildContext context) => screenWidth(context) * 0.35;
  static double movieCardHeight(BuildContext context) => screenHeight(context) * 0.25;
  
  // Text sizes that scale with device
  static double headingSize(BuildContext context) => screenWidth(context) * 0.05;
  static double bodyTextSize(BuildContext context) => screenWidth(context) * 0.035;
  
  // Section padding that scales
  static double sectionPadding(BuildContext context) => screenWidth(context) * 0.04;
}
