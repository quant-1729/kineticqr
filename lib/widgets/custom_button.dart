import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kineticqr/utils/Constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final VoidCallback onPressed;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.backgroundColor,
      required this.textColor,
      required this.onPressed,
      this.height = 52})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(left: 5.0.h),
        decoration: BoxDecoration(
          color: Appcolor.yellow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Appcolor.yellowText(context),
          ),
        ),
        padding: EdgeInsets.all(10.h),
        height: height.h,
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
