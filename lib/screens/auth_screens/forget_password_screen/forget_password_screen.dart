import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../providers/forgot/forgot_provider.dart';
import '../../../widgets/field_widget.dart';
import '../../../widgets/submit_button.dart';
import '../new_password_screen/new_password_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var forgotP = Provider.of<ForgotProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("", [], isIconShow: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget1(text: "Forgot Password", fontSize: 20.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor),
            SizedBox(height: 30,),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
              text: "Please Write you",
              style: TextStyle(color: textColor,fontSize: 16.dp,),
              children: [
                TextSpan(text: " Email ",style: TextStyle(color: themeColor,fontSize: 16.dp)),
                TextSpan(text: "to recive the confirmation code to set",style: TextStyle(color: textColor,fontSize: 16.dp)),
                TextSpan(text: " new password",style: TextStyle(color: themeColor,fontSize: 16.dp)),
              ]
            )),
            SizedBox(height: 30,),
            Form(
              key: formKey,
              child: InputField(
                inputController: forgotP.emailC,
                prefixIcon: Container(
                    padding: EdgeInsets.all(24),
                    height: 9.h,
                    child: Image.asset(ImagesPath.emailIcon)),
                hintText: "Email",
              ),
            ),
            SizedBox(height: 30,),
            Center(
              child: SubmitButton(
                  radius: 15,
                  width: 70.w,
                  title: "Confirm Email",
                  press: (){
                    if(formKey.currentState!.validate()){
                      // forgotP.emailExist();
                      Get.to(()=>NewPasswordScreen());
                    }
                  }
              ),
            ),

          ],
        ),
      ),
    );
  }
}
