import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/providers/dashboard/dashboard_provider.dart';
import 'package:tiinver_project/providers/profile/profile_provider.dart';
import 'package:tiinver_project/screens/app_screens/mediaScreen/profile_media_screen.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/images_path.dart';
import '../../../../constants/text_widget.dart';
import '../../../../models/feedTimeLineModel/feed_time_line_model.dart';
import '../../../../providers/signIn/sign_in_provider.dart';
import '../../../../widgets/image_loader_widget.dart';
import '../../dash_board_screen/comp/media_widget.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signP = Provider.of<SignInProvider>(context, listen: false);
    final dashboardP = Provider.of<DashboardProvider>(context,listen: false);
    final profileP = Provider.of<ProfileProvider>(context, listen: false);

    profileP.getUserProfile(context);
    profileP.fetchMedia(
        int.parse(signP.userId.toString()),
        int.parse(signP.userId.toString()),
        100,
        0,
        signP.userApiKey.toString());
    return SizedBox(
      width: 100.w,
      child: Consumer<ProfileProvider>(builder: (context, value, child) {
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
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
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
                                Get.to(() => ProfileMediaScreen(
                                  activity: activity,
                                  // activities: value.media,
                                  initialIndex: index,
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
      },),
    );
  }
}
