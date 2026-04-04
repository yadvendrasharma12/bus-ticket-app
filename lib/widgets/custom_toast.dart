import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppToast {
  static void _show(
      BuildContext context,
      String message,
      Color bgColor,
      ) {
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, Colors.redAccent);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Colors.green);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, Colors.blueAccent);
  }
}