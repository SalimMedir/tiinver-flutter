import 'package:get/get.dart';
import 'package:tiinver_project/routes/routes_name.dart';
import 'package:tiinver_project/screens/app_screens/bottom_navbar_screen/bottom_navbar_screen.dart';
import 'package:tiinver_project/screens/app_screens/camera/camera.dart';
import 'package:tiinver_project/screens/app_screens/settingScreen/setting_screen.dart';
import 'package:tiinver_project/screens/auth_screens/forget_password_screen/forget_password_screen.dart';
import 'package:tiinver_project/screens/auth_screens/new_password_screen/new_password_screen.dart';
import 'package:tiinver_project/screens/auth_screens/onboarding_screen/onboarding_screen.dart';
import 'package:tiinver_project/screens/auth_screens/otp_screen/otp_screen.dart';
import 'package:tiinver_project/screens/auth_screens/sign_up_screen/sign_up_screen.dart';
import 'package:tiinver_project/screens/auth_screens/signin_screen/sign_in_screen.dart';
import 'package:tiinver_project/screens/auth_screens/splash_screen/splash_screen.dart';


class Routes{
  static final routes  = [
    GetPage(
        name: RoutesName.splashScreen,
        page: ()=> SplashScreen()
    ),
    GetPage(
        name: RoutesName.signIn,
        page: ()=> SignInScreen()
    ),
    GetPage(
        name: RoutesName.signUp,
        page: ()=> SignUpScreen()
    ),
    GetPage(
        name: RoutesName.forgotPassword,
        page: ()=> ForgetPasswordScreen()
    ),
    GetPage(
        name: RoutesName.newPassword,
        page: ()=> NewPasswordScreen()
    ),
    GetPage(
        name: RoutesName.otpVerificationScreen,
        page: ()=> OtpScreen()
    ),
    GetPage(
        name: RoutesName.bottomNavigationBar,
        page: ()=> BottomNavbarScreen()
    ),
    GetPage(
        name: RoutesName.settingScreen,
        page: ()=> SettingScreen()
    ),
    GetPage(
        name: RoutesName.onboardingScreen,
        page: ()=> OnboardingScreen()
    ),
    // GetPage(
    //     name: RoutesName.graphicScreen,
    //     page: ()=> GraphicScreen(user: "",)
    // ),
    GetPage(
        name: RoutesName.cameraScreen,
        page: ()=> CameraScreen()
    ),
  ];
}