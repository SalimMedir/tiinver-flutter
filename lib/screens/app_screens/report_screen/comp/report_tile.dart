import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';

class ReportTile extends StatelessWidget {
  const ReportTile({super.key,required this.title,required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 12,
      onTap: onTap,
      title: TextWidget1(text: title, fontSize: 24.dp, fontWeight: FontWeight.w700,
          isTextCenter: false, textColor: textColor),
      trailing: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: themeColor,
          shape: BoxShape.circle
        ),
        child: Center(child: Icon(CupertinoIcons.forward,color: bgColor,size: 18,)),
      ),
    );
  }
}
