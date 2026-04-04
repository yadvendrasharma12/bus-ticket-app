import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;

    final bool isDisabled = onPressed == null || isLoading;

    final Color effectiveBgColor = isDisabled
        ? Colors.yellow.shade900
        : (backgroundColor ?? Colors.white);

    final Color effectiveTextColor = isDisabled
        ? Colors.white70
        : (textColor ?? Colors.white);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: buttonWidth,
      height: 45,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: borderColor ?? Colors.yellowAccent,
              width: borderColor != null ? 1 : 0,
            ),
          ),
          elevation: 2,
        ),

        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          text,
          style: GoogleFonts.poppins(
            color: effectiveTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}