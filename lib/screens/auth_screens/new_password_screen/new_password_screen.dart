import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../providers/forgot/forgot_provider.dart';
import '../../../widgets/field_widget.dart';
import '../../../widgets/header.dart';
import '../../../widgets/submit_button.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

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
            TextWidget1(text: "New Password", fontSize: 20.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor),

            SizedBox(height: 30,),
            TextWidget1(text: "Please write your new password", fontSize: 16.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: textColor),

            SizedBox(height: 30,),
            Consumer<ForgotProvider>(builder: (context, value, child) {
              return InputField(
                inputController: forgotP.passwordC,
                obscureText: value.obscureText1,
                prefixIcon: Container(
                    padding: EdgeInsets.all(24),
                    height: 9.h,
                    child: Image.asset(ImagesPath.lockIcon)),
                hintText: "Password",
                suffixIcon: IconButton(
                    onPressed: (){
                      value.hidePassword();
                    },
                    icon: Icon(value.obscureText1 ? Icons.visibility_off_outlined
                        : Icons.visibility)
                ),
              );
            },),

            SizedBox(height: 30,),
            Consumer<ForgotProvider>(
              builder: (context, value, child) {
              return InputField(
                inputController: forgotP.confirmPasswordC,
                obscureText: value.obscureText2,
                prefixIcon: Container(
                    padding: EdgeInsets.all(24),
                    height: 9.h,
                    child: Image.asset(ImagesPath.lockIcon)),
                hintText: "Confirm Password",
                suffixIcon: IconButton(
                    onPressed: (){
                      value.hideConfirmPassword();
                    },
                    icon: Icon(value.obscureText2 ? Icons.visibility_off_outlined
                        : Icons.visibility)
                ),
              );
            },),

            SizedBox(height: 30,),
            Center(
              child: Consumer<ForgotProvider>(builder: (context, value, child) {
                return value.isLoading ? CircularProgressIndicator()
                    : SubmitButton(
                    radius: 15,
                    width: 70.w,
                    title: "Confirm Password",
                    press: (){
                      if(value.passwordC.text == value.confirmPasswordC.text){
                        value.newPasswordReset();
                      }else{
                        Get.snackbar("Error", "Passwords are not same!");
                      }
                    }
                );
              },),
            ),
          ],
        ),
      ),
    );
  }
}
