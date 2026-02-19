import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/providers/chat/chat_provider.dart';
import 'package:tiinver_project/providers/chatActivityProvider/chat_activity_provider.dart';
import 'package:tiinver_project/providers/chatsocket_provider.dart';
import 'package:tiinver_project/providers/connectedUsers/connected_users_provider.dart';
import 'package:tiinver_project/providers/createGroup/create_group_provider.dart';
import 'package:tiinver_project/providers/dashboard/dashboard_provider.dart';
import 'package:tiinver_project/providers/forgot/forgot_provider.dart';
import 'package:tiinver_project/providers/graphic/graphic_provider.dart';
import 'package:tiinver_project/providers/message/message_provider.dart';
import 'package:tiinver_project/providers/notification/notification_provider.dart';
import 'package:tiinver_project/providers/onboard/onboard_provider.dart';
import 'package:tiinver_project/providers/otherUserProfile/other_user_profile_provider.dart';
import 'package:tiinver_project/providers/otp/otp_provider.dart';
import 'package:tiinver_project/providers/profile/profile_provider.dart';
import 'package:tiinver_project/providers/search/search_provider.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import 'package:tiinver_project/providers/signUp/sign_up_provider.dart';
import 'package:tiinver_project/providers/suggestions/suggestions_provider.dart';
import 'package:tiinver_project/providers/uploadingProgressProvider/uploading_progress_provider.dart';
import 'package:tiinver_project/routes/routes.dart';
import 'package:tiinver_project/routes/routes_name.dart';
import 'package:tiinver_project/screens/app_screens/camera/camera.dart';

import 'SocketIO/socket_io.dart';
import 'constants/colors.dart';
import 'firebase_options.dart';
import 'gloabal_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSizer(
        builder: (context, orientation, screenType) {
          return MultiProvider(
              providers: [

            ChangeNotifierProvider(create: (_)=> OnboardProvider()),
            ChangeNotifierProvider(create: (_)=> SignInProvider()),
            ChangeNotifierProvider(create: (_)=> SignUpProvider()),
            ChangeNotifierProvider(create: (_)=> ForgotProvider()),
            ChangeNotifierProvider(create: (_)=> OtpProvider()),
            ChangeNotifierProvider(create: (_)=> ProfileProvider()),
            ChangeNotifierProvider(create: (_)=> SearchProvider()),
            ChangeNotifierProvider(create: (_)=> ConnectedUsersProvider()..fetchConnectedUsers(context)),
            ChangeNotifierProvider(create: (_)=> CreateGroupProvider()),
            ChangeNotifierProvider(create: (_)=> DashboardProvider()),
            ChangeNotifierProvider(create: (_)=> OtherUserProfileProvider()),
            ChangeNotifierProvider(create: (_)=> SuggestionsProvider()),
            ChangeNotifierProvider(create: (_)=> GraphicProvider()),
            ChangeNotifierProvider(create: (_)=> NotificationProvider()),
            ChangeNotifierProvider(create: (_)=> MessageProvider()),
            ChangeNotifierProvider(create: (_)=> ChatProvider()),
            ChangeNotifierProvider(create: (_)=> ChatActivitySendButtonProvider()),
            ChangeNotifierProvider(create: (_)=> UploadingProgressBarProvider()),
            ChangeNotifierProvider(create: (_)=> SocketProvider()),

          ],
            child: GetMaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Tiinver',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: themeColor,primary: themeColor),
                useMaterial3: true,
              ),
              //home: ChatScreen(userId: "197", chatId: "197_2200"),
              initialRoute: RoutesName.splashScreen,
              getPages: Routes.routes,
            ),
          );
        }
    );
  }
}

