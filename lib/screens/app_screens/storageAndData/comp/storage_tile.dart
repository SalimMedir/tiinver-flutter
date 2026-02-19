import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_widget.dart';

class StorageTile extends StatelessWidget {
  const StorageTile({
    super.key,
    required this.title,
    required this.trailing
  });

  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: themeColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
      title: TextWidget1(
          text: title,
          fontSize: 16.dp,
          fontWeight: FontWeight.w700,
          isTextCenter: false,
          textColor: bgColor),
      subtitle: TextWidget1(
          text: "All media",
          fontSize: 15.dp,
          fontWeight: FontWeight.w500,
          isTextCenter: false,
          textColor: bgColor),
      trailing: trailing,
    );
  }
}
