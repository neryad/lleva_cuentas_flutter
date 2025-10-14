// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeManager extends ChangeNotifier {
//   static const String _themeColorKey = 'theme_color';
//   static const String _isDarkModeKey = 'is_dark_mode';

//   late SharedPreferences _prefs;
//   Color _seedColor = const Color(0xff1e234b);
//   bool _isDarkMode = true;

//   Color get seedColor => _seedColor;
//   bool get isDarkMode => _isDarkMode;

//   ThemeManager() {
//     _init();
//   }

//   Future<void> _init() async {
//     _prefs = await SharedPreferences.getInstance();
//     loadTheme();
//   }

//   void loadTheme() {
//     final savedColorInt = _prefs.getInt(_themeColorKey);
//     if (savedColorInt != null) {
//       _seedColor = Color(savedColorInt);
//     }
//     _isDarkMode = _prefs.getBool(_isDarkModeKey) ?? true;
//     notifyListeners();
//   }

//   Future<void> setSeedColor(Color color) async {
//     _seedColor = color;
//     await _prefs.setInt(_themeColorKey, color.value);
//     notifyListeners();
//   }

//   Future<void> setDarkMode(bool isDark) async {
//     _isDarkMode = isDark;
//     await _prefs.setBool(_isDarkModeKey, isDark);
//     notifyListeners();
//   }

//   ThemeData getThemeData() {
//     final colorScheme = ColorScheme.fromSeed(
//       seedColor: _seedColor,
//       brightness: _isDarkMode ? Brightness.dark : Brightness.light,
//     );

//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: colorScheme,
//       brightness: _isDarkMode ? Brightness.dark : Brightness.light,
//       appBarTheme: AppBarTheme(
//         backgroundColor: colorScheme.surface,
//         foregroundColor: colorScheme.onSurface,
//         elevation: 0,
//       ),
//       scaffoldBackgroundColor: colorScheme.surface,
//       cardTheme: CardThemeData(
//         color: colorScheme.surfaceContainer,
//         elevation: 1,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: colorScheme.primary,
//           foregroundColor: colorScheme.onPrimary,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }

//   // Colores predefinidos sugeridos
//   static const List<Color> predefinedColors = [
//     Color(0xff1e234b), // Original
//     Color(0xff6366f1), // Indigo
//     Color(0xff8b5cf6), // Violet
//     Color(0xffec4899), // Pink
//     Color(0xfff43f5e), // Rose
//     Color(0xfff97316), // Orange
//     Color(0xffeab308), // Yellow
//     Color(0xff22c55e), // Green
//     Color(0xff06b6d4), // Cyan
//     Color(0xff3b82f6), // Blue
//     Color(0xffe11d48), // Red
//     Color(0xff7c3aed), // Purple
//   ];
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  static const String _themeColorKey = 'theme_color';
  static const String _isDarkModeKey = 'is_dark_mode';

  SharedPreferences? _prefs;
  Color _seedColor = const Color(0xff1e234b);
  bool _isDarkMode = true;

  Color get seedColor => _seedColor;
  bool get isDarkMode => _isDarkMode;

  ThemeManager() {
    _initAsync();
  }

  Future<void> _initAsync() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTheme();
    notifyListeners();
  }

  void _loadTheme() {
    if (_prefs == null) return;

    final savedColorInt = _prefs!.getInt(_themeColorKey);
    if (savedColorInt != null) {
      _seedColor = Color(savedColorInt);
    }
    _isDarkMode = _prefs!.getBool(_isDarkModeKey) ?? true;
  }

  Future<void> setSeedColor(Color color) async {
    _seedColor = color;
    if (_prefs != null) {
      await _prefs!.setInt(_themeColorKey, color.value);
    }
    notifyListeners();
  }

  Future<void> setDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    if (_prefs != null) {
      await _prefs!.setBool(_isDarkModeKey, isDark);
    }
    notifyListeners();
  }

  ThemeData getThemeData() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        elevation: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Colores predefinidos sugeridos
  static const List<Color> predefinedColors = [
    Color(0xff1e234b), // Original
    Color(0xff6366f1), // Indigo
    Color(0xff8b5cf6), // Violet
    Color(0xffec4899), // Pink
    Color(0xfff43f5e), // Rose
    Color(0xfff97316), // Orange
    Color(0xffeab308), // Yellow
    Color(0xff22c55e), // Green
    Color(0xff06b6d4), // Cyan
    Color(0xff3b82f6), // Blue
    Color(0xffe11d48), // Red
    Color(0xff7c3aed), // Purple
  ];
}
