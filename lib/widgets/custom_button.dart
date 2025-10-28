import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  /// optional colors — agar user na de to default values
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor, // optional
    this.textColor,       // optional
    this.borderColor,     // optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9; // 90% width

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      width: buttonWidth,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white, // default white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: borderColor ?? Colors.transparent, // border optional
              width: borderColor != null ? 1 : 0, // only show if given
            ),
          ),
          elevation: 2, // optional shadow
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: textColor ?? Colors.black, // default black
          ),
        ),
      ),
    );
  }
}
