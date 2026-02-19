import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../constants/text_widget.dart';
import '../../../models/followingModel/following_model.dart';
import '../../../providers/profile/profile_provider.dart';
import '../../../providers/signIn/sign_in_provider.dart';
import '../../../widgets/header.dart';
import '../other_user_profile_screen/other_user_profile_screen.dart';
import '../search_screen/comp/searching_tile.dart';

class UserFollowingScreen extends StatefulWidget {
  UserFollowingScreen({super.key,required this.userId});

  int userId;

  @override
  State<UserFollowingScreen> createState() => _UserFollowingScreenState();
}

class _UserFollowingScreenState extends State<UserFollowingScreen> {

  final Map<int, bool> _loadingStates = {};

  @override
  Widget build(BuildContext context) {
    var updateP = Provider.of<ProfileProvider>(context, listen: false);
    var signInP = Provider.of<SignInProvider>(context, listen: false);
    updateP.following(widget.userId, context);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("Following",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isCenterTitle: true,
          isIconShow: true),
      body: StreamBuilder<List<FollowingUsers>>(
        stream: updateP.followingStream,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: TextWidget1(
                text: "No Following",
                fontSize: 24.dp,
                fontWeight: FontWeight.w700,
                isTextCenter: false,
                textColor: textColor,
              ),
            );
          } else {
            final List<FollowingUsers> followingsList = snapshot.data!;

            return ListView.builder(
              itemCount: followingsList.length,
              itemBuilder: (context, index) {
                final user = followingsList[index];
                final isLoading = updateP.isLoadingForUser(user.id!);

                return InkWell(
                  onTap: () {
                    Get.off(() => OtherUserProfileScreen(userId: user.id!));
                  },
                  child: SearchingTile(
                    name: '${user.firstname}',
                    userName: user.username.toString(),
                    imageUrl: user.profile.toString(),
                    buttonText: user.isFollowed == false ? "Follow Back" : "Friends",
                    buttonAction: () async {
                      setState(() {
                        _loadingStates[user.id!] = true;
                      });

                      try {
                        await updateP.follow(
                          followId: signInP.userId.toString(),
                          userId: user.id.toString(),
                          userApiKey: signInP.userApiKey.toString(),
                        );
                        await updateP.followers(widget.userId, context);
                      } catch (e) {
                        // Handle error
                      } finally {
                        setState(() {
                          _loadingStates[user.id!] = false;
                        });
                      }

                      log("tap");
                    },
                    isLoading: isLoading,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
