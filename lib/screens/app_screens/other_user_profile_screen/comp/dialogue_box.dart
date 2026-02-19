import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';

class DialogueBox{
  Widget customDialogue(context,{required String title,required String subTitle,
    required String primaryButtonText,required VoidCallback primaryTap}){
    return Dialog(
      backgroundColor: bgColor,
      surfaceTintColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
            TextWidget1(text: title, fontSize: 16.dp, fontWeight: FontWeight.w500,
                isTextCenter: false, textColor: themeColor),
            SizedBox(height: 30,),
            TextWidget1(text: subTitle, fontSize: 14.dp, fontWeight: FontWeight.w500,
                isTextCenter: false, textColor: darkGreyColor),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: 70,
                    height: 40,
                    child: Center(
                      child: TextWidget1(text: "Cancel", fontSize: 16.dp, fontWeight: FontWeight.w500,
                          isTextCenter: false, textColor: themeColor),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                InkWell(
                  onTap: primaryTap,
                  child: SizedBox(
                    width: 70,
                    height: 40,
                    child: Center(
                      child: TextWidget1(text: primaryButtonText, fontSize: 16.dp, fontWeight: FontWeight.w500,
                          isTextCenter: false, textColor: themeColor),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}