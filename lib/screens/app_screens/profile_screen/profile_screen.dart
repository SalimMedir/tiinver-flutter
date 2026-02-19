import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../providers/profile/profile_provider.dart';
import '../../../providers/signIn/sign_in_provider.dart';
import '../../../widgets/header.dart';
import '../../../widgets/image_loader_widget.dart';
import '../settingScreen/setting_screen.dart';
import '../user_followers_screen/user_followers_screen.dart';
import '../user_following_screen/user_following_screen.dart';
import 'media_screen/media_screen.dart';
import 'my_profile_screen/my_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signP = Provider.of<SignInProvider>(context, listen: false);
    final profileP = Provider.of<ProfileProvider>(context, listen: false);

    profileP.getUserProfile(context);
    profileP.fetchMedia(
        int.parse(signP.userId.toString()),
        int.parse(signP.userId.toString()),
        100,
        0,
        signP.userApiKey.toString());

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: Header().header1(
              "",
              [
                PopupMenuButton(
                  surfaceTintColor: bgColor,
                  color: bgColor,
                  child: SizedBox(
                      width: 7.w, child: Image.asset(ImagesPath.menuIcon)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        Get.to(() => SettingScreen());
                      },
                      value: 'Item 1',
                      child: TextWidget1(
                          text: "Settings",
                          fontSize: 16.dp,
                          fontWeight: FontWeight.w700,
                          isTextCenter: false,
                          textColor: themeColor),
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
              ],
              isIconShow: false),
          body: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: bgColor,
                          border: Border.all(
                              color: themeColor, width: 2.dp)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lightGreyColor),
                            child: ImageLoaderWidget(
                                imageUrl: profileP.userModel.profile
                                    .toString()),
                          )),
                    ),
                    Positioned(
                      top: 20,
                      right: 5,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: themeColor, shape: BoxShape.circle),
                        child: Image.asset(
                          ImagesPath.checkIcon,
                          color: bgColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Consumer<ProfileProvider>(
                builder: (context, value, child) {
                  return Center(
                    child: TextWidget1(
                      text: profileP.userModel.firstname.toString(),
                      fontSize: 24.dp,
                      fontWeight: FontWeight.w700,
                      isTextCenter: true,
                      textColor: themeColor,
                      maxLines: 2,
                    ),
                  );
                },
              ),
              Consumer<ProfileProvider>(
                builder: (context, value, child) {
                  return Center(
                    child: TextWidget1(
                        text: profileP.userModel.username.toString(),
                        fontSize: 10.dp,
                        fontWeight: FontWeight.w500,
                        isTextCenter: false,
                        textColor: darkGreyColor),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Get.to(() => UserFollowingScreen(
                            userId: int.parse(signP.userId!)));
                      },
                      child: Consumer<ProfileProvider>(
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              TextWidget1(
                                  text:
                                      profileP.userModel.following.toString(),
                                  fontSize: 20.dp,
                                  fontWeight: FontWeight.w500,
                                  isTextCenter: false,
                                  textColor: darkGreyColor),
                              TextWidget1(
                                  text: "Following",
                                  fontSize: 16.dp,
                                  fontWeight: FontWeight.w500,
                                  isTextCenter: false,
                                  textColor: themeColor),
                            ],
                          );
                        },
                      )),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Get.to(() => UserFollowersScreen(
                            userId: int.parse(signP.userId!),
                          ));
                    },
                    child: Consumer<ProfileProvider>(
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            TextWidget1(
                                text: profileP.userModel.followers.toString(),
                                fontSize: 20.dp,
                                fontWeight: FontWeight.w500,
                                isTextCenter: false,
                                textColor: darkGreyColor),
                            TextWidget1(
                                text: "Followers",
                                fontSize: 16.dp,
                                fontWeight: FontWeight.w500,
                                isTextCenter: false,
                                textColor: themeColor),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: lightGreyColor,
                child: TabBar(
                    indicatorColor: darkGreyColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        icon: TextWidget1(
                            text: "My Profile",
                            fontSize: 14.dp,
                            fontWeight: FontWeight.w500,
                            isTextCenter: false,
                            textColor: textColor),
                      ),
                      Tab(
                        icon: TextWidget1(
                            text: "Media",
                            fontSize: 14.dp,
                            fontWeight: FontWeight.w500,
                            isTextCenter: false,
                            textColor: textColor),
                      ),
                    ]),
              ),
              SizedBox(
                  height: 70.h,
                  width: 100.w,
                  child: const TabBarView(
                      children: [
                        MyProfileScreen(),
                        MediaScreen()
                      ]))
            ],
          ),
        ));
  }
}
//model1: profileP.userModel!,model2: provider.user!,
//value.userModel!.userData.username.toString()
