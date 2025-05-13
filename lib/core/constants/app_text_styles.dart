// lib/core/constants/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_dimensions.dart';

class AppTextStyles {
  // Light mode text styles
  static TextStyle titleLight(BuildContext context) => TextStyle(
    fontSize: AppDimensions.headingM(context),
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  
  static TextStyle subtitleLight(BuildContext context) => TextStyle(
    fontSize: AppDimensions.textXL(context),
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  
  static TextStyle bodyLight(BuildContext context) => TextStyle(
    fontSize: AppDimensions.textM(context),
    color: Colors.black87,
  );
  
  static TextStyle captionLight(BuildContext context) => TextStyle(
    fontSize: AppDimensions.textS(context),
    color: Colors.grey.shade600,
  );
  
  // Dark mode text styles
  static TextStyle titleDark(BuildContext context) => TextStyle(
    fontSize: AppDimensions.headingM(context),
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static TextStyle subtitleDark(BuildContext context) => TextStyle(
    fontSize: AppDimensions.textXL(context),
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static TextStyle bodyDark(BuildContext context) => TextStyle(
    fontSize: AppDimensions.textM(context),
    color: Colors.white,
  );
  
  static TextStyle captionDark(BuildContext context) => TextStyle(
    fontSize: AppDimensions.textS(context),
    color: Colors.grey.shade400,
  );
  
  // Responsive styles that adjust based on theme
  static TextStyle title(BuildContext context, bool isDarkMode) => 
    isDarkMode ? titleDark(context) : titleLight(context);
  
  static TextStyle subtitle(BuildContext context, bool isDarkMode) => 
    isDarkMode ? subtitleDark(context) : subtitleLight(context);
  
  static TextStyle body(BuildContext context, bool isDarkMode) => 
    isDarkMode ? bodyDark(context) : bodyLight(context);
  
  static TextStyle caption(BuildContext context, bool isDarkMode) => 
    isDarkMode ? captionDark(context) : captionLight(context);
  
  // Movie card specific styles
  static TextStyle movieTitle(BuildContext context, bool isDarkMode) => TextStyle(
    fontSize: AppDimensions.textL(context),
    fontWeight: FontWeight.bold,
    color: isDarkMode ? Colors.white : Colors.black87,
    overflow: TextOverflow.ellipsis,
  );
  
  static TextStyle movieYear(BuildContext context, bool isDarkMode) => TextStyle(
    fontSize: AppDimensions.textS(context),
    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
  );
}