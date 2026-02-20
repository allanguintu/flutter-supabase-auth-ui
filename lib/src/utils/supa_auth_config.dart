import 'package:flutter/material.dart';

/// Global configuration for Supabase Auth UI widgets.
///
/// Wrap your widget tree (e.g. inside `MaterialApp.builder`) with this widget
/// to customise the behaviour of all auth UI components at once:
///
/// ```dart
/// SupaAuthConfig(
///   snackBarBehavior: SnackBarBehavior.floating,
///   child: MyApp(),
/// )
/// ```
class SupaAuthConfig extends InheritedWidget {
  /// Controls whether snackbars are displayed floating or fixed.
  /// Defaults to [SnackBarBehavior.floating].
  final SnackBarBehavior snackBarBehavior;

  const SupaAuthConfig({
    super.key,
    this.snackBarBehavior = SnackBarBehavior.floating,
    required super.child,
  });

  /// Returns the nearest [SupaAuthConfig] ancestor, or a default instance if
  /// none is found.
  static SupaAuthConfig of(BuildContext context) {
    final config =
        context.dependOnInheritedWidgetOfExactType<SupaAuthConfig>();
    // Return a default config if none is provided in the widget tree.
    if (config == null) {
      return const SupaAuthConfig(child: SizedBox.shrink());
    }
    return config;
  }

  @override
  bool updateShouldNotify(SupaAuthConfig oldWidget) {
    return snackBarBehavior != oldWidget.snackBarBehavior;
  }
}
