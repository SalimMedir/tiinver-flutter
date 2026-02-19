import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/widgets/field_widget.dart';
import 'package:tiinver_project/widgets/header.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

class MsgScreen extends StatelessWidget {
  MsgScreen({super.key});

  var msgC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("New Messages", [], isIconShow: true,isCenterTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h,),
              TextWidget1(
                  text: "Enter a phone number or email in the field above"
                      " Make sure they are correct. If you are not sure, ask"
                      " the recipient of the message to send you by SMS or"
                      " other method, the phone number or email he has used"
                      " to create the tiinver Account.",
                  maxLines: 7,
                  fontSize: 12.dp,
                  fontWeight: FontWeight.w500,
                  isTextCenter: true, textColor: textColor),
              SizedBox(height: 5.h,),
              TextWidget1(
                  text: "New Messages",
                  fontSize: 20.dp,
                  fontWeight: FontWeight.w600,
                  isTextCenter: false, textColor: themeColor),
              SizedBox(height: 5.h,),
              TextWidget1(
                  text: "Email or Phone Number",
                  decoration: TextDecoration.underline,
                  fontSize: 14.dp,
                  fontWeight: FontWeight.w600,
                  isTextCenter: false, textColor: themeColor),
              SizedBox(height: 5.h,),
              InputField(
                  inputController: msgC,
                hintText: "Messag....",
              ),
              SizedBox(height: 5.h,),
              Center(
                child: SubmitButton(
                  width: 50.w,
                    title: "Send",
                    press: (){}
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
