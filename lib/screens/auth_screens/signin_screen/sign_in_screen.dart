import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/images_path.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/widgets/field_widget.dart';
import 'package:tiinver_project/widgets/header.dart';
import 'package:tiinver_project/widgets/submit_button.dart';
import '../../../providers/signIn/sign_in_provider.dart';
import '../forget_password_screen/forget_password_screen.dart';
import '../sign_up_screen/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
 const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  var formKey = GlobalKey<FormState>();

  var emailC = TextEditingController();

  var passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
 final signInProvider = Provider.of<SignInProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("", [], isIconShow: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h,),
              TextWidget1(text: "Sign In", fontSize: 20.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor),

              SizedBox(height: 20,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    InputField(
                      inputController: emailC,
                      prefixIcon: Container(
                          padding: EdgeInsets.all(24),
                          height: 9.h,
                          child: Image.asset(ImagesPath.emailIcon)),
                      hintText: "Email",
                    ),

                    SizedBox(height: 20,),
                    Consumer<SignInProvider>(builder: (context, value, child) {
                      return InputField(
                        inputController: passwordC,
                        obscureText: value.obscureText,
                        prefixIcon: Container(
                            padding: EdgeInsets.all(24),
                            height: 9.h,
                            child: Image.asset(ImagesPath.lockIcon)),
                        suffixIcon: IconButton(
                            onPressed: (){
                              value.hidePassword();
                            },
                            icon: Icon(value.obscureText ? Icons.visibility_off_outlined
                                : Icons.visibility
                            )),
                        hintText: "Password",

                      );
                    },
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(()=>ForgetPasswordScreen());
                    },
                    child: SizedBox(
                        height: 30,
                        child: Center(child: TextWidget1(text: "Forget Password?", fontSize: 12.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor))),
                  ),
                ],
              ),
              SizedBox(height: 70,),

              Center(
                child: Consumer<SignInProvider>(builder: (context,value,child){
                  return value.isLoading ? CircularProgressIndicator()
                      : SubmitButton(
                      radius: 15,
                      width: 70.w,
                      title: "Sign in",
                      press: (){
                        if(formKey.currentState!.validate()){

                            signInProvider.login(emailC.text, passwordC.text,context);

                        }
                      }
                  );
                }),
              ),
              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget1(text: "New User?", fontSize: 16.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: textColor),
                  GestureDetector(
                      onTap: (){
                        Get.to(()=> SignUpScreen());
                      },
                      child: TextWidget1(text: "Register Now", fontSize: 16.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: themeColor)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
