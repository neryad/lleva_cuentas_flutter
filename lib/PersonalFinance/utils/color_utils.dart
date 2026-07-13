import 'dart:ui';

Color hexToColor(String hex) {
  hex = hex.replaceFirst('#', '');
  return Color(int.parse('FF$hex', radix: 16));
}
