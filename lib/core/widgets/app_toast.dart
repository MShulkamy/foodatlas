import 'package:flutter/material.dart';

/// Simple SnackBar-based toast helper.
/// Replaces the `fluttertoast` package, which fails to build on newer
/// Flutter/Kotlin toolchains (Built-in Kotlin migration issue).
class AppToast {
  AppToast._();

  static void show(BuildContext context, String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : null,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
