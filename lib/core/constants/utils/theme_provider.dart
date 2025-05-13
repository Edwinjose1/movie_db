import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
 bool _isDarkMode = true; // Default to dark mode
 bool get isDarkMode => _isDarkMode;

 ThemeProvider() {
   _loadThemeFromPrefs();
 }

 // Load theme preference from SharedPreferences
 Future<void> _loadThemeFromPrefs() async {
   final prefs = await SharedPreferences.getInstance();
   _isDarkMode = prefs.getBool('isDarkMode') ?? true;
   notifyListeners();
 }

 // Toggle theme between light and dark
 void toggleTheme() {
   _isDarkMode = !_isDarkMode;
   _saveThemeToPrefs();
   notifyListeners();
 }

 // Set specific theme
 void setDarkMode(bool value) {
   _isDarkMode = value;
   _saveThemeToPrefs();
   notifyListeners();
 }

 // Save theme preference to SharedPreferences
 Future<void> _saveThemeToPrefs() async {
   final prefs = await SharedPreferences.getInstance();
   await prefs.setBool('isDarkMode', _isDarkMode);
 }

 // Get the current theme data
 ThemeData get currentTheme {
   return _isDarkMode 
       ? ThemeData.dark().copyWith(
           primaryColor: Colors.blueGrey[800],
           colorScheme: ColorScheme.dark(
             primary: Colors.blueGrey[800]!,
             secondary: Colors.tealAccent,
           ),
         )
       : ThemeData.light().copyWith(
           primaryColor: Colors.blue,
           colorScheme: ColorScheme.light(
             primary: Colors.blue,
             secondary: Colors.teal,
           ),
         );
 }
}