import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';

class SubmitButton extends StatelessWidget {
  SubmitButton({
    super.key,
    required this.title,
    this.icon,
    required this.press,
    this.height,
    this.width,
    this.radius,
    this.bdColor,
    this.iconColor,
    this.textSize,
    this.iconSize,
    this.bdRadius,
    this.textC,
    this.gradientColors,
  });
  final String? title;
  final Widget? icon;
  final Function() press;
  final double? height;
  final double? width;
  final double? radius;
  final Color? bdColor, textC;
  final Color? iconColor;
  final double? textSize;
  final double? iconSize;
  final double? bdRadius;
  LinearGradient? gradientColors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        width: width ?? double.infinity,
        alignment: Alignment.center,
        height: height ?? 60.0,
        decoration: BoxDecoration(
            color: bdColor ?? themeColor,
            borderRadius: BorderRadius.circular(radius ?? 10.0),
            gradient: gradientColors,
            border: Border.all(
              color: themeColor
            ),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  color: Colors.grey.withOpacity(.5))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(right: title != null ? 8.0 : 0.0),
                child: icon,
              ),
            if (title != null)
              Text(
                title!,
                style: TextStyle(
                    color: textC ?? bgColor, fontWeight: FontWeight.bold,fontSize: textSize ?? 16.dp),
              ),

          ],
        ),
      ),
    );
  }
}