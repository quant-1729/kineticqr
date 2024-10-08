import 'package:flutter/material.dart';
import 'package:kineticqr/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class Appcolor {
  static Color yellow = const Color(0xFFFDB623);

  static Color yellowText(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.themeMode == ThemeMode.dark
        ? const Color(0xFFFDB623)
        : Colors.black;
  }

  static Color textColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.themeMode == ThemeMode.dark
        ? const Color(0xFFFDB623)
        : Colors.black;
  }

  static Color cardColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.themeMode == ThemeMode.dark
        ? const Color(0xFF424242)
        : const Color(0xFFFFF9C4);
  }

  // appBarColor remains the same as before
  static Color appBarColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.themeMode == ThemeMode.dark
        ? const Color(0xFF333333)
        : const Color(0xFFFFFFFF);
  }

  // navBarColor remains the same as before
  static Color navBarColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.themeMode == ThemeMode.dark
        ? const Color(0xFF212121)
        : const Color(0xFFEEEEEE);
  }

  // backgroundColor should be light yellowish in light mode and a darker color in dark mode
  static Color backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.themeMode == ThemeMode.dark
        ? const Color(0xFF121212)
        : const Color(0xFFFFFDE7); // Very light yellowish in light mode
  }

  // bg is a semi-transparent background color, adjusted for theme
  static Color bg(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.themeMode == ThemeMode.dark
        ? const Color(0xFF353535).withOpacity(.8)
        : const Color(0xFFF0F0F0).withOpacity(.8);
  }
}
