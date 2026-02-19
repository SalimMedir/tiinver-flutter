import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/images_path.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import '../../../providers/otp/otp_provider.dart';
import '../../../providers/signUp/sign_up_provider.dart';


class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});


  @override
  Widget build(BuildContext context) {
    var otpP = Provider.of<OtpProvider>(context,listen: false);
    final signUpProvider =   Provider.of<SignUpProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      // appBar: Header().header("", []),
      appBar: AppBar(
        surfaceTintColor: bgColor,
        backgroundColor: bgColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextWidget1(text: "Enter the Code", fontSize: 24.dp, fontWeight: FontWeight.w600, isTextCenter: false, textColor: textColor),
          SizedBox(height: 30,),
          TextWidget1(text: "We have emailed you an activation code", fontSize: 16.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: darkGreyColor),
          SizedBox(height: 30,),
          Center(
            child: Pinput(
              onTapOutside: (value){
                FocusScope.of(context).unfocus();
              },
              length: 4,
              onCompleted: (pin) {
                if(otpP.code == int.parse(pin)){
                  signUpProvider.signUp(context);
                }else{
                  Get.snackbar("error", "invalid OTP");
                }
              },
              defaultPinTheme: PinTheme(
                width: 20.w,
                height: 56,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: lightGreyColor),
                ),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Consumer<OtpProvider>(builder: (context, value, child) {
            return TextWidget1(text: "Tiinver will send the code to you in : ${otpP.start}",
                fontSize: 16.dp, fontWeight: FontWeight.w500,
                isTextCenter: false, textColor: darkGreyColor);
          },),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 63.w,
                  child: TextWidget1(text: "If you have not received the code", fontSize: 16.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: darkGreyColor,maxLines: 2,)),
              GestureDetector(
                onTap: () async{

                },
                child: SizedBox(
                    width: 20.w,
                    child: Center(child: TextWidget1(text: "Click here", fontSize: 16.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: themeColor))),
              ),
            ],
          ),
          SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: lightGreyColor
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 8.w,
                      child: Image.asset(ImagesPath.warningIcon)),
                  SizedBox(width: 5,),
                  SizedBox(
                      width: 70.w,
                      child: TextWidget1(text: "If the message is not in your inbox please check spam.", fontSize: 16.dp, fontWeight: FontWeight.w400, isTextCenter: false, textColor: themeColor,maxLines: 2,)),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
