import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../widgets/header.dart';

class AccountPrivacyScreen extends StatefulWidget {
  const AccountPrivacyScreen({super.key});

  @override
  State<AccountPrivacyScreen> createState() => _AccountPrivacyScreenState();
}

class _AccountPrivacyScreenState extends State<AccountPrivacyScreen> {

  bool isCommentTrue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1(
          "Account Privacy",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isCenterTitle: true,
          isIconShow: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20),
        child: Column(
          children: [
            SizedBox(height: 100,),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                children: [
                  TextWidget1(text: "Account Private", fontSize: 16.dp,
                      fontWeight: FontWeight.w600, isTextCenter: false, textColor: bgColor),
                  const Spacer(),
                  Switch(
                    value: isCommentTrue,
                    inactiveTrackColor: themeColor,
                    inactiveThumbColor: bgColor,
                    activeColor: bgColor,
                    hoverColor: bgColor,

                    onChanged: (value) {
                      setState(() {
                        isCommentTrue = value;
                      });
                    },)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
