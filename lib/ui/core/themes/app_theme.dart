import 'package:material_ui/material_ui.dart';

abstract final class AppTheme {
  static const _seedColor = Color(0xFFF5A524);

  static ThemeData get light => _themeFor(Brightness.light);

  static ThemeData get dark => _themeFor(Brightness.dark);

  static ThemeData _themeFor(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        indicatorShape: const StadiumBorder(),
      ),
    );
  }
}
