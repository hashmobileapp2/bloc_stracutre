import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/size_constants.dart';
import '../../common/extensions/size_extensions.dart';
import 'theme_color.dart';

class ThemeText {
  const ThemeText._();

  static TextTheme get _poppinsTextTheme => GoogleFonts.poppinsTextTheme();

  static TextStyle? get _whitetitleLarge =>
      _poppinsTextTheme.titleLarge?.copyWith(
        fontSize: Sizes.dimen_20.sp,
        color: Colors.white,
      );

  static TextStyle? get _whiteheadlineSmall =>
      _poppinsTextTheme.headlineSmall?.copyWith(
        fontSize: Sizes.dimen_24.sp,
        color: Colors.white,
      );

  static TextStyle? get whitetitleMedium =>
      _poppinsTextTheme.titleMedium?.copyWith(
        fontSize: Sizes.dimen_16.sp,
        color: Colors.white,
      );

  static TextStyle? get _whiteButton => _poppinsTextTheme.labelLarge?.copyWith(
        fontSize: Sizes.dimen_14.sp,
        color: Colors.white,
      );

  static TextStyle? get whitebodyMedium =>
      _poppinsTextTheme.bodyMedium?.copyWith(
        color: Colors.white,
        fontSize: Sizes.dimen_14.sp,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _darkbodySmall => _poppinsTextTheme.bodySmall?.copyWith(
        color: AppColor.vulcan,
        fontSize: Sizes.dimen_14.sp,
        wordSpacing: 0.25,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle? get _vulcantitleLarge =>
      _whitetitleLarge?.copyWith(color: AppColor.vulcan);

  static TextStyle? get _vulcanheadlineSmall =>
      _whiteheadlineSmall?.copyWith(color: AppColor.vulcan);

  static TextStyle? get vulcantitleMedium =>
      whitetitleMedium?.copyWith(color: AppColor.vulcan);

  static TextStyle? get vulcanbodyMedium =>
      whitebodyMedium?.copyWith(color: AppColor.vulcan);

  static TextStyle? get _lightbodySmall =>
      _darkbodySmall?.copyWith(color: Colors.white);

  static getTextTheme() => TextTheme(
        headlineSmall: _whiteheadlineSmall,
        titleLarge: _whitetitleLarge,
        titleMedium: whitetitleMedium,
        bodyMedium: whitebodyMedium,
        labelLarge: _whiteButton,
        bodySmall: _darkbodySmall,
      );

  static getLightTextTheme() => TextTheme(
        headlineSmall: _vulcanheadlineSmall,
        titleLarge: _vulcantitleLarge,
        titleMedium: vulcantitleMedium,
        bodyMedium: vulcanbodyMedium,
        labelLarge: _whiteButton,
        bodySmall: _lightbodySmall,
      );
}

extension ThemeTextExtension on TextTheme {
  TextStyle? get royalBluetitleMedium => titleMedium?.copyWith(
      color: AppColor.royalBlue, fontWeight: FontWeight.w600);

  TextStyle? get greytitleMedium => titleMedium?.copyWith(color: Colors.grey);

  TextStyle? get violettitleLarge =>
      titleLarge?.copyWith(color: AppColor.violet);

  TextStyle? get vulcanbodyMedium =>
      bodyMedium?.copyWith(color: AppColor.vulcan, fontWeight: FontWeight.w600);

  TextStyle? get whitebodyMedium =>
      vulcanbodyMedium?.copyWith(color: Colors.white);

  TextStyle? get greybodySmall => bodySmall?.copyWith(color: Colors.grey);

  TextStyle? get orangetitleMedium =>
      titleMedium?.copyWith(color: Colors.orangeAccent);
}
