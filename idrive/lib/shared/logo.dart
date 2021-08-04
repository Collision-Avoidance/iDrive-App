import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget buildLogo() {
  return Expanded(
    child: Container(
      alignment: Alignment.center,
      height: 50.h,
      width: 50.w,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: ExactAssetImage('assets/images/logo.png'),
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}