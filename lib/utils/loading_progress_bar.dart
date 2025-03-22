// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../presentation/themes/theme_color.dart';

class LoadingProgressBar extends StatelessWidget {
  Color? color = Colors.white;
  double? width = 5.0;
  double? height = 5.0;
  String? source;

  LoadingProgressBar({
    super.key,
    this.color,
    this.width,
    this.height,
    this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: ShapeDecoration(
        color: color ?? AppColor.violet,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
      child: const Center(
        child: SizedBox(
          height: 35,
          width: 35,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}
