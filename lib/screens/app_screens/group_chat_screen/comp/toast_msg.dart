import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';

class ToastMsg extends StatelessWidget {
  const ToastMsg({super.key,this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: themeColor,
          borderRadius: BorderRadius.circular(6)
        ),
        child: TextWidget1(text: text!, fontSize: 9.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: bgColor),
      ),
    );
  }
}
