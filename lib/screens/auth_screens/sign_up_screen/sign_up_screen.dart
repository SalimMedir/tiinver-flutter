import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/widgets/header.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../providers/otp/otp_provider.dart';
import '../../../providers/signUp/sign_up_provider.dart';
import '../../../widgets/field_widget.dart';
import '../../../widgets/submit_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var signUpP = Provider.of<SignUpProvider>(context,listen: false);
    var otpP = Provider.of<OtpProvider>(context,listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColor,
      appBar: Header().header1("", [], isIconShow: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: [

          SizedBox(height: 10.h,),
          TextWidget1(text: "Sign Up", fontSize: 20.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor),

          SizedBox(height: 20,),
          Form(
            key: formKey,
            child: Column(
              children: [
                InputField(
                  inputController: signUpP.nameC,
                  prefixIcon: Container(
                      padding: EdgeInsets.all(24),
                      height: 9.h,
                      child: Image.asset(ImagesPath.person)),
                  hintText: "Full Name",
                ),

                SizedBox(height: 20,),
                InputField(
                  inputController: signUpP.emailC,
                  prefixIcon: Container(
                      padding: EdgeInsets.all(24),
                      height: 9.h,
                      child: Image.asset(ImagesPath.emailIcon)),
                  hintText: "Email",
                ),
                SizedBox(height: 20,),

                Consumer<SignUpProvider>(
                  builder: (context, value, child) {
                  return InputField(
                    inputController: signUpP.passwordC,
                    obscureText: value.obscureText1,
                    prefixIcon: Container(
                        padding: EdgeInsets.all(24),
                        height: 9.h,
                        child: Image.asset(ImagesPath.lockIcon)),
                    suffixIcon: IconButton(
                        onPressed: (){
                          value.hidePassword();
                        },
                        icon: Icon(value.obscureText1 ? Icons.visibility_off_outlined
                            :Icons.visibility)),
                    hintText: "Password",
                  );
                },),

                SizedBox(height: 20,),
                Consumer<SignUpProvider>(
                  builder: (context, value, child) {
                  return InputField(
                    inputController: signUpP.confirmPasswordC,
                    obscureText: value.obscureText2,
                    prefixIcon: Container(
                        padding: EdgeInsets.all(24),
                        height: 9.h,
                        child: Image.asset(ImagesPath.lockIcon)),
                    suffixIcon: IconButton(
                        onPressed: () {
                          value.hideConfirmPassword();
                        },
                        icon: Icon(value.obscureText2 ? Icons.visibility_off_outlined
                        : Icons.visibility)),
                    hintText: "Password",
                  );
                },),
              ],
            ),
          ),

          SizedBox(height: 70,),
          Center(
            child: Consumer<SignUpProvider>(builder: (context, value, child) {
              return value.isLoading ? CircularProgressIndicator()
                  : SubmitButton(
                  radius: 15,
                  width: 70.w,
                  title: "Sign up",
                  press: () async {
                    // FirebaseFirestore.instance.collection("user").doc("31434324").set({
                    //       "userId" : "093214309413241"
                    //     });
                    if(signUpP.passwordC.text == signUpP.confirmPasswordC.text){
                      if(formKey.currentState!.validate()){
                        otpP.otpSend(signUpP.emailC.text);
                      }
                    }else{
                     Get.snackbar("Error", "Passwords are not same!");
                    }
                  }
              );
            },),
          ),

          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget1(text: "Already have an Account?", fontSize: 16.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: textColor),
              GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: TextWidget1(text: "Login", fontSize: 16.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: themeColor)),
            ],
          )
        ],
      ),
    );
  }
}
