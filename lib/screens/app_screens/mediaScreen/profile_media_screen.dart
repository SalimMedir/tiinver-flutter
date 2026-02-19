import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../models/feedTimeLineModel/feed_time_line_model.dart';
import '../../../providers/dashboard/dashboard_provider.dart';
import '../../../providers/otherUserProfile/other_user_profile_provider.dart';
import '../../../providers/profile/profile_provider.dart';
import '../../../providers/signIn/sign_in_provider.dart';
import '../../../widgets/field_widget.dart';
import '../../../widgets/image_loader_widget.dart';
import '../other_user_profile_screen/other_user_profile_screen.dart';

class ProfileMediaScreen extends StatelessWidget {

  final Activity activity;
  final int initialIndex;
  // final List<Activity> activities;

  ProfileMediaScreen({
    super.key,
    required this.activity,
    // required this.activities,
    required this.initialIndex,
  });

  late VideoPlayerController _controller;

  late Future<List<Comment>> _commentsFuture;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    final dashboardProvider =
    Provider.of<DashboardProvider>(context, listen: false);
    final profileProvider =
    Provider.of<ProfileProvider>(context, listen: false);
    final otherProfileProvider =
    Provider.of<OtherUserProfileProvider>(context, listen: false);
    dashboardProvider.fetchComments(activity.id!, signInProvider.userApiKey!);

    return Scaffold(
      backgroundColor: textColor,
      body: PageView.builder(
        controller: dashboardProvider.pageController,
        itemCount: profileProvider.media.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final activity = profileProvider.media[index];

          return Stack(
            children: [
              Center(
                child: activity.isImage()
                    ? Image.network(activity.objectUrl!, fit: BoxFit.cover)
                    : activity.isVideo()
                    ? ProfileVideoPlayerScreen(activity: activity)
                    : Container(
                  height: 100.h,
                  width: 100.w,
                  color: lightGreyColor,
                ),
              ),
              activity.isImage()
                  ? SizedBox(
                height: 12.h,
                width: 100.w,
                child: AppBar(
                  backgroundColor: textColor,
                  surfaceTintColor: textColor,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: bgColor),
                  ),
                  title: InkWell(
                    onTap: () async {
                      Get.to(() => OtherUserProfileScreen(
                          userId: activity.userId!));
                      // if (activity.isVideo()) {
                      //   // Pause video if playing
                      //   await dashboardProvider.controller.pause().whenComplete(() {
                      //
                      //   },);
                      // }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: ImageLoaderWidget(
                                imageUrl: activity.profile!),
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: 40.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget1(
                                text: activity.firstname!,
                                fontSize: 18.dp,
                                fontWeight: FontWeight.w700,
                                isTextCenter: false,
                                textColor: bgColor,
                              ),
                              TextWidget1(
                                text: activity.username!,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                isTextCenter: false,
                                textColor: bgColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Get.bottomSheet(
                            isScrollControlled: true,
                            Container(
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 1.5.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(
                                      color: themeColor,
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(50)),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  activity.userId.toString() ==
                                      signInProvider.userId
                                      ? SizedBox()
                                      : ListTile(
                                    onTap: () {
                                      profileProvider.follow(
                                          followId: activity.userId
                                              .toString(),
                                          userId: signInProvider
                                              .userId
                                              .toString(),
                                          userApiKey: signInProvider
                                              .userApiKey
                                              .toString());
                                      Get.back();
                                    },
                                    leading: Icon(
                                      Icons.person,
                                      color: darkGreyColor,
                                    ),
                                    title: TextWidget1(
                                      text:
                                      "Unfollow @${activity.username}",
                                      fontSize: 14.dp,
                                      fontWeight: FontWeight.w500,
                                      isTextCenter: false,
                                      textColor: textColor,
                                      maxLines: 1,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.delete,
                                      color: darkGreyColor,
                                    ),
                                    title: TextWidget1(
                                        text: "delete post",
                                        fontSize: 14.dp,
                                        fontWeight: FontWeight.w500,
                                        isTextCenter: false,
                                        textColor: textColor),
                                  ),
                                  activity.userId.toString() ==
                                      signInProvider.userId
                                      ? SizedBox()
                                      : ListTile(
                                    leading: Icon(
                                      Icons.info_rounded,
                                      color: darkGreyColor,
                                    ),
                                    title: TextWidget1(
                                        text: "report post",
                                        fontSize: 14.dp,
                                        fontWeight: FontWeight.w500,
                                        isTextCenter: false,
                                        textColor: textColor),
                                  ),
                                  activity.userId.toString() ==
                                      signInProvider.userId
                                      ? SizedBox()
                                      : ListTile(
                                    onTap: () {
                                      profileProvider.follow(
                                          followId: activity.userId
                                              .toString(),
                                          userId: signInProvider
                                              .userId
                                              .toString(),
                                          userApiKey: signInProvider
                                              .userApiKey
                                              .toString());
                                      Get.back();
                                    },
                                    leading: Icon(
                                      Icons.block_rounded,
                                      color: darkGreyColor,
                                    ),
                                    title: TextWidget1(
                                      text:
                                      "Block @${activity.username}",
                                      fontSize: 14.dp,
                                      fontWeight: FontWeight.w500,
                                      isTextCenter: false,
                                      textColor: textColor,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.ellipsis_vertical,
                          color: bgColor,
                        ))
                  ],
                ),
              )
                  : SizedBox(),
              Consumer<ProfileProvider>(
                builder: (context, value, child) {
                return Positioned(
                  bottom: 20,
                  left: 20,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          dashboardProvider
                              .likeOrUnlike(
                            activityId: activity.id.toString(),
                            userId: signInProvider.userId.toString(),
                            userApiKey: signInProvider.userApiKey.toString(),
                          )
                              .whenComplete(() {
                            profileProvider.fetchMedia(
                              int.parse(signInProvider.userId.toString()),
                              int.parse(signInProvider.userId.toString()),
                              100,
                              0,
                              signInProvider.userApiKey.toString(),
                            );
                          });
                        },
                        child: SizedBox(
                          width: 8.w,
                          child: Image.asset(
                            ImagesPath.likeIcon,
                            color: activity.isLiked! ? Colors.red : bgColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      TextWidget1(
                        text: "${activity.likes ?? ''}",
                        fontSize: 20.dp,
                        fontWeight: FontWeight.w700,
                        isTextCenter: false,
                        textColor: bgColor,
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          var commentProvider = Provider.of<DashboardProvider>(
                              context,
                              listen: false);
                          commentProvider.fetchComments(
                              activity.id!, signInProvider.userApiKey!);
                          Get.bottomSheet(
                            isScrollControlled: true,
                            Container(
                              height: 50.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 1.5.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(
                                      color: themeColor,
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(50)),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Expanded(
                                    child: StreamBuilder<List<Comment>>(
                                      stream: commentProvider.commentStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: CircularProgressIndicator());
                                        }

                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        }

                                        if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                              child: Text('No comments found.'));
                                        }

                                        List<Comment> comments = snapshot.data!;

                                        return ListView.builder(
                                          itemCount: comments.length,
                                          itemBuilder: (context, index) {
                                            final comment = comments[index];
                                            return Container(
                                              padding: EdgeInsets.all(20),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 2.5.h,
                                                    backgroundImage: NetworkImage(
                                                        comment.profile!),
                                                  ),
                                                  SizedBox(width: 20),
                                                  Container(
                                                    width: 70.w,
                                                    padding:
                                                    const EdgeInsets.all(10),
                                                    decoration:
                                                    const BoxDecoration(
                                                      color: lightGreyColor,
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(5),
                                                        topRight:
                                                        Radius.circular(20),
                                                        bottomLeft:
                                                        Radius.circular(20),
                                                        bottomRight:
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        TextWidget1(
                                                          text:
                                                          "${comment.firstname} ${comment.lastname}",
                                                          fontSize: 10.dp,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          isTextCenter: false,
                                                          textColor: themeColor,
                                                        ),
                                                        TextWidget1(
                                                          text: comment
                                                              .commentText!,
                                                          fontSize: 10.dp,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          isTextCenter: false,
                                                          textColor:
                                                          darkGreyColor,
                                                          maxLines: 5,
                                                          overFlow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5),
                                    child: Consumer<DashboardProvider>(
                                      builder: (context, value, child) {
                                        return Form(
                                          key: formKey,
                                          child: InputField(
                                            inputController: value.commentC,
                                            hintText: "Comment...",
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                if (value
                                                    .commentC.text.isNotEmpty) {
                                                  value
                                                      .postComment(
                                                    activityId:
                                                    activity.id!.toString(),
                                                    userId: signInProvider.userId
                                                        .toString(),
                                                    userApiKey: signInProvider
                                                        .userApiKey
                                                        .toString(),
                                                  )
                                                      .whenComplete(() {
                                                    commentProvider.fetchComments(
                                                        activity.id!,
                                                        signInProvider
                                                            .userApiKey!);
                                                    Provider.of<DashboardProvider>(
                                                        context,
                                                        listen: false)
                                                        .fetchTimeline(
                                                      int.parse(signInProvider
                                                          .userId
                                                          .toString()),
                                                      100,
                                                      0,
                                                      signInProvider.userApiKey
                                                          .toString(),
                                                    );
                                                  });
                                                }
                                              },
                                              child: value.isLoading
                                                  ? SizedBox(
                                                height: 30,
                                                width: 30,
                                                child:
                                                CircularProgressIndicator(),
                                              )
                                                  : Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical: 10,
                                                    horizontal: 20),
                                                child: Image.asset(
                                                  ImagesPath.sendIcon,
                                                  height: 2.h,
                                                ),
                                              ),
                                            ),
                                            bdRadius: 50,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 8.w,
                          child: Image.asset(ImagesPath.chatIcon),
                        ),
                      ),
                      SizedBox(width: 10),
                      TextWidget1(
                        text: activity.comment.toString() ?? '',
                        fontSize: 20.dp,
                        fontWeight: FontWeight.w700,
                        isTextCenter: false,
                        textColor: bgColor,
                      ),
                    ],
                  ),
                );
              },),
            ],
          );
        },
      ),
    );
  }
}

class ProfileVideoPlayerScreen extends StatelessWidget {
  final Activity activity;

  const ProfileVideoPlayerScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    final profileProvider =
    Provider.of<ProfileProvider>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider()..initialize(activity.objectUrl!),
      child: Consumer<DashboardProvider>(
        builder: (context, videoProvider, child) {
          return GestureDetector(
            onTap: () {
              if (videoProvider.controller.value.isPlaying) {
                videoProvider.controller.pause();
              } else {
                videoProvider.controller.play();
              }
            },
            child: Column(
              children: [
                SizedBox(
                  height: 12.h,
                  width: 100.w,
                  child: AppBar(
                    backgroundColor: textColor,
                    surfaceTintColor: textColor,
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: bgColor),
                    ),
                    title: InkWell(
                      onTap: () async {
                        if (activity.isVideo()) {
                          // Pause video if playing
                          await videoProvider.controller.pause().whenComplete(
                                () {
                              Get.to(() => OtherUserProfileScreen(
                                  userId: activity.userId!));
                            },
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: ImageLoaderWidget(
                                  imageUrl: activity.profile!),
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 40.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget1(
                                  text: activity.firstname!,
                                  fontSize: 18.dp,
                                  fontWeight: FontWeight.w700,
                                  isTextCenter: false,
                                  textColor: bgColor,
                                ),
                                TextWidget1(
                                  text: activity.username!,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  isTextCenter: false,
                                  textColor: bgColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Get.bottomSheet(
                              isScrollControlled: true,
                              Container(
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 1.5.h,
                                      width: 30.w,
                                      decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(50)),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    activity.userId.toString() ==
                                        signInProvider.userId
                                        ? SizedBox()
                                        : ListTile(
                                      onTap: () {
                                        profileProvider.follow(
                                            followId: activity.userId
                                                .toString(),
                                            userId: signInProvider.userId
                                                .toString(),
                                            userApiKey: signInProvider
                                                .userApiKey
                                                .toString());
                                        Get.back();
                                      },
                                      leading: Icon(
                                        Icons.person,
                                        color: darkGreyColor,
                                      ),
                                      title: TextWidget1(
                                        text:
                                        "Unfollow @${activity.username}",
                                        fontSize: 14.dp,
                                        fontWeight: FontWeight.w500,
                                        isTextCenter: false,
                                        textColor: textColor,
                                        maxLines: 1,
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.delete,
                                        color: darkGreyColor,
                                      ),
                                      title: TextWidget1(
                                          text: "delete post",
                                          fontSize: 14.dp,
                                          fontWeight: FontWeight.w500,
                                          isTextCenter: false,
                                          textColor: textColor),
                                    ),
                                    activity.userId.toString() ==
                                        signInProvider.userId
                                        ? SizedBox()
                                        : ListTile(
                                      leading: Icon(
                                        Icons.info_rounded,
                                        color: darkGreyColor,
                                      ),
                                      title: TextWidget1(
                                          text: "report post",
                                          fontSize: 14.dp,
                                          fontWeight: FontWeight.w500,
                                          isTextCenter: false,
                                          textColor: textColor),
                                    ),
                                    activity.userId.toString() ==
                                        signInProvider.userId
                                        ? SizedBox()
                                        : ListTile(
                                      leading: Icon(
                                        Icons.block_rounded,
                                        color: darkGreyColor,
                                      ),
                                      title: TextWidget1(
                                        text:
                                        "Block @${activity.username}",
                                        fontSize: 14.dp,
                                        fontWeight: FontWeight.w500,
                                        isTextCenter: false,
                                        textColor: textColor,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            CupertinoIcons.ellipsis_vertical,
                            color: bgColor,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  width: 100.w,
                  height: 80.h,
                  child: AspectRatio(
                    aspectRatio: videoProvider.controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(videoProvider.controller),
                        videoProvider.controller.value.isPlaying
                            ? SizedBox()
                            : Icon(
                          Icons.play_arrow,
                          size: 50,
                          color: bgColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // videoProvider.controller.value.isInitialized
            //     ?
            //     : Container(
            //   height: 200.0,
            //   color: Colors.grey,
            //   child: Center(child: CircularProgressIndicator()),
            // ),
          );
        },
      ),
    );
  }
}