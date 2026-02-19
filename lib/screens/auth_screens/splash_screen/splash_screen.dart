import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/images_path.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import '../../../providers/signIn/sign_in_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Provider.of<SignInProvider>(context,listen: false).getUserApiKey(context);
    },);
  }

  @override
  Widget build(BuildContext context) {
    // final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    //final connectedUsersProvider = Provider.of<ConnectedUsersProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 30.h,
                child: Image.asset(ImagesPath.splashImage)),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget1(text: "Welcome", fontSize: 16.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor),
                TextWidget1(text: " To Tiinver", fontSize: 16.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: textColor),
              ],
            )
          ],
        ),
      ),
    );
  }
}
