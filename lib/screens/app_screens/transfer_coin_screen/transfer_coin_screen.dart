import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/widgets/field_widget.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../widgets/header.dart';
import '../../../widgets/submit_button.dart';

class TransferCoinScreen extends StatelessWidget {
  TransferCoinScreen({super.key});

  var emailC = TextEditingController();

  var amountC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("0 Coins",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isCenterTitle: true,
          isIconShow: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: TextWidget1(text: "Transfer Coins", fontSize: 24.dp, fontWeight: FontWeight.w700,
                    isTextCenter: false, textColor: textColor),
              ),
              SizedBox(height: 20,),
              ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(ImagesPath.earnImage)),
              SizedBox(height: 20,),
              TextWidget1(text: "Email", fontSize: 20.dp, fontWeight: FontWeight.w600,
                  isTextCenter: false, textColor: themeColor,decoration: TextDecoration.underline,),
              InputField(
                  inputController: emailC,
                hintText: "Email..",
              ),
              SizedBox(height: 20,),
              TextWidget1(text: "Select Amount", fontSize: 20.dp, fontWeight: FontWeight.w600,
                  isTextCenter: false, textColor: themeColor,decoration: TextDecoration.underline,),
              InputField(
                  inputController: emailC,
                hintText: "0.00",
              ),
              SizedBox(height: 20,),
              SubmitButton(
                  radius: 50,
                  title: "Transfer",
                  press: (){

                  }
              )

            ],
          ),
        ),
      ),
    );
  }
}
