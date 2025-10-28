


import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';



class AppStyle{





  static TextStyle appBarText({double size = 15, FontWeight weight = FontWeight.w600}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: Colors.indigo.shade800,
    );

  }
  static TextStyle userText1({double size = 26, FontWeight weight = FontWeight.w700}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: AppColors.appBarText,
    );

  }
  static TextStyle userText2({double size = 14, FontWeight weight = FontWeight.w500}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: AppColors.textBlack,
    );

  }
}