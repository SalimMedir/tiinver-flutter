import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/images_path.dart';
import 'package:tiinver_project/providers/otherUserProfile/other_user_profile_provider.dart';
import 'package:tiinver_project/providers/profile/profile_provider.dart';
import 'package:tiinver_project/screens/app_screens/mediaScreen/profile_media_screen.dart';
import 'package:tiinver_project/screens/app_screens/other_user_profile_screen/comp/following_status.dart';
import 'package:tiinver_project/screens/app_screens/other_user_profile_screen/comp/profile_container.dart';
import 'package:tiinver_project/screens/app_screens/report_screen/report_screen.dart';
import 'package:tiinver_project/screens/app_screens/user_following_screen/user_following_screen.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../constants/text_widget.dart';
import '../../../models/feedTimeLineModel/feed_time_line_model.dart';
import '../../../providers/dashboard/dashboard_provider.dart';
import '../../../providers/signIn/sign_in_provider.dart';
import '../../../widgets/image_loader_widget.dart';
import '../dash_board_screen/comp/media_widget.dart';
import '../mediaScreen/other_profile_media_screen.dart';
import '../user_followers_screen/user_followers_screen.dart';
import 'comp/dialogue_box.dart';

class OtherUserProfileScreen extends StatelessWidget {

  OtherUserProfileScreen({super.key,required this.userId});

  int userId;

  @override
  Widget build(BuildContext context) {
    Provider.of<OtherUserProfileProvider>(context,listen: false).getOtherUserProfile(context,userId);
    var profileP = Provider.of<ProfileProvider>(context,listen: false);
    var signInP = Provider.of<SignInProvider>(context, listen: false);
    var otherUserProfileP = Provider.of<OtherUserProfileProvider>(context,listen: false);
    final dashboardP = Provider.of<DashboardProvider>(context,listen: false);

    profileP.getUserProfile(context);
    otherUserProfileP.fetchMedia(
        userId,
        int.parse(signInP.userId.toString()),
        100,
        0,
        signInP.userApiKey.toString());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("Profile",
          [
            PopupMenuButton(
              surfaceTintColor: bgColor,
              color: bgColor,
              child: SizedBox(
                  width: 7.w,
                  child: Image.asset(ImagesPath.menuIcon)),
              itemBuilder: (context) =>[
              PopupMenuItem(
                onTap: (){
                  Get.to(()=> ReportScreen(
                    userId: otherUserProfileP.userModel!.id!.toString(),
                    userName: otherUserProfileP.userModel!.username!.toString(),
                  ));
                },
                value: 'Item 1',
                child: TextWidget1(text: "Report", fontSize: 16.dp,
                    fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor),),
                PopupMenuItem(
                  onTap: (){
                    showDialog(
                        context: context, 
                        builder: (context) {
                          return DialogueBox().customDialogue(
                              context,
                              title: "Block Reminder ?",
                              subTitle: "If you block the user you are not gona "
                                  "see his activity on tinver",
                              primaryButtonText: "Block",
                              primaryTap: (){
                                Get.back();
                                otherUserProfileP.blockUser(
                                    userId: signInP.userId ?? "",
                                    userName: profileP.userModel.username ?? "",
                                    userApiKey: signInP.userApiKey ?? "",
                                    blockUserName: otherUserProfileP.userModel!.username!.toString(),
                                    blockUserId: otherUserProfileP.userModel!.id!.toString());
                              }
                          );
                        },
                    );
                  },
                  value: 'Item 2',
                  child: TextWidget1(text: "Block", fontSize: 16.dp,
                      fontWeight: FontWeight.w700, isTextCenter: false, textColor: themeColor),),
            ],),
            SizedBox(width: 10,),
          ],
          isIconShow: true, isCenterTitle: true),
      body: ListView(
        shrinkWrap: true,
        children: [
          Consumer<OtherUserProfileProvider>(
            builder: (context, value, child) {
            return value.isLoading ? SizedBox()
                : Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    ProfileContainer(
                      name: value.userModel!.firstname!,
                      userName: value.userModel!.username!,
                      image: value.userModel!.profile!,
                    ),
                    SizedBox(height: 8.h,)
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: 80.w,
                  decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow:  [
                         BoxShadow(
                            color: lightGreyColor,
                            blurRadius: 2
                        ),
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.off(()=>UserFollowingScreen(userId: value.userModel!.id!,));
                        },
                        child: FollowingStatus(
                          followNumber: value.userModel!.following!.toString(),
                          followText: "Following",
                          buttonText: value.userModel!.isFollowed == false ? "Follow" : "Following",
                          icon: Icon(Icons.person,size: 14.dp,color: bgColor,),
                          onTap: () {
                            profileP.follow(
                                followId: signInP.userId.toString(),
                                userId: value.userModel!.id.toString(),
                                userApiKey: signInP.userApiKey.toString(),
                            ).whenComplete(() {
                              otherUserProfileP.getOtherUserProfile(context,userId);
                            },);
                          },
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      InkWell(
                        onTap: () {
                          Get.off(()=>UserFollowersScreen(userId: value.userModel!.id!,));
                        },
                        child: FollowingStatus(
                          followNumber: value.userModel!.followers!.toString(),
                          followText: "Followers",
                          buttonText: "Message",
                          onTap: () {
                            // FirebaseAccountHandling.addChatUserToMyContact(context, value.userModel!.id!.toString());
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },),
          SizedBox(height: 30,),
          SizedBox(
            width: 100.w,
            child: Consumer<OtherUserProfileProvider>(
              builder: (context, value, child) {
              return StreamBuilder<List<Activity>>(
                stream: value.mediaStream,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No activities available'));
                  } else {
                    final List<Activity> activities = snapshot.data!;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: activities.length,
                      itemBuilder: (BuildContext context, int index) {
                        final activity = activities[index];
                        return SizedBox(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 27.h,
                                  width: 45.w,
                                  color: lightGreyColor,
                                  child: MediaWidget(
                                    onTap: () {
                                      log("tap");
                                      dashboardP.setCurrentPage(index);
                                      Get.to(() => OtherProfileMediaScreen(
                                        activity: activity,
                                        // activities: value.media,
                                        otherUserId: userId,
                                      ));
                                    },
                                    activity: activity,activities: value.media,initialIndex: index,),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: lightGreyColor,
                                                shape: BoxShape.circle
                                            ),
                                            child: ImageLoaderWidget(imageUrl: activity.profile!),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        SizedBox(
                                          width: 20.w,
                                          child: TextWidget1(text: '${activity.firstname} ${activity.lastname}',
                                              fontSize: 10.dp, fontWeight: FontWeight.w700,
                                              maxLines: 1, overFlow: TextOverflow.ellipsis,
                                              isTextCenter: false, textColor: bgColor),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextWidget1(text: "${activity.message}", fontSize: 10.dp,
                                          fontWeight: FontWeight.w700, isTextCenter: false,maxLines: 1,
                                          textColor: bgColor, overFlow: TextOverflow.ellipsis,),
                                        SizedBox(height: 6,),
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 4.w,
                                                child: Image.asset(ImagesPath.likeIcon,color: activity.isLiked! ? Colors.red : bgColor,)),
                                            SizedBox(width: 5,),
                                            TextWidget1(text: "${activity.likes ?? ''}", fontSize: 10.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: bgColor),
                                            SizedBox(width: 5,),
                                            SizedBox(
                                                width: 4.w,
                                                child: Image.asset(ImagesPath.chatIcon)),
                                            SizedBox(width: 10,),
                                            TextWidget1(text: activity.comment.toString() ?? '', fontSize: 10.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: bgColor),

                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 27.h,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10
                    ),
                    );
                  }
                },
              );
            },
            ),
          ),
        ],
      ),
    );
  }
}


// Center(child: TextWidget1(text: "No Data Found", fontSize: 16.dp, fontWeight: FontWeight.w800, isTextCenter: false, textColor: textColor)),
// GridView.builder(
//   physics: NeverScrollableScrollPhysics(),
//   shrinkWrap: true,
//   padding: EdgeInsets.symmetric(horizontal: 20),
//   itemCount: 10,
//   itemBuilder: (BuildContext context, int index) {
//     return Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Container(
//             width: 45.w,
//             child: Image.asset(ImagesPath.dashBoardImage,fit: BoxFit.cover,),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 2.5.h,
//                     backgroundImage: AssetImage(ImagesPath.profileImage),
//                   ),
//                   SizedBox(width: 10,),
//                   TextWidget1(text: "Reminder", fontSize: 10.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: bgColor),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextWidget1(text: "Infinity Image", fontSize: 10.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: bgColor),
//                   SizedBox(height: 6,),
//                   Row(
//                     children: [
//                       SizedBox(
//                           width: 4.w,
//                           child: Image.asset(ImagesPath.likeIcon)),
//                       SizedBox(width: 5,),
//                       TextWidget1(text: "10k", fontSize: 10.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: bgColor),
//                       SizedBox(width: 5,),
//                       SizedBox(
//                           width: 4.w,
//                           child: Image.asset(ImagesPath.chatIcon)),
//                       SizedBox(width: 10,),
//                       TextWidget1(text: "1278", fontSize: 10.dp, fontWeight: FontWeight.w700, isTextCenter: false, textColor: bgColor),
//
//                     ],
//                   )
//                 ],
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     mainAxisExtent: 25.h,
//     crossAxisSpacing: 10,
//     mainAxisSpacing: 10
// ),
// ),
