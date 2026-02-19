import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiinver_project/constants/colors.dart';

class NavigateButton extends StatelessWidget {
  NavigateButton({super.key,required this.icon,required this.height,
    required this.width,required this.iconSize});

  IconData icon;
  double height;
  double width;
  double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: themeColor,
        shape: BoxShape.circle
      ),
      child: Center(child: Icon(icon,color: bgColor,size: iconSize,)),
    );
  }
}
