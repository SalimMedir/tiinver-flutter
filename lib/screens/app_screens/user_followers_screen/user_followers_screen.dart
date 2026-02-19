import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import 'package:tiinver_project/screens/app_screens/search_screen/comp/searching_tile.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../constants/images_path.dart';
import '../../../models/followersModel/followers_model.dart';
import '../../../providers/profile/profile_provider.dart';
import '../other_user_profile_screen/other_user_profile_screen.dart';

class UserFollowersScreen extends StatefulWidget {
  const UserFollowersScreen({super.key, required this.userId});

  final int userId;

  @override
  State<UserFollowersScreen> createState() => _UserFollowersScreenState();
}

class _UserFollowersScreenState extends State<UserFollowersScreen> {
  final Map<int, bool> _loadingStates = {};

  @override
  Widget build(BuildContext context) {
    final updateP = Provider.of<ProfileProvider>(context, listen: false);
    final signInP = Provider.of<SignInProvider>(context, listen: false);

    // Start fetching followers when the screen is built
    updateP.followers(widget.userId, context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1(
        "Followers",
        [
          SizedBox(width: 7.w, child: Image.asset(ImagesPath.menuIcon)),
          SizedBox(width: 15),
        ],
        isCenterTitle: true,
        isIconShow: true,
      ),
      body: StreamBuilder<List<Users>>(
        stream: updateP.followersStream,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: TextWidget1(
                text: "No Followers",
                fontSize: 24.dp,
                fontWeight: FontWeight.w700,
                isTextCenter: false,
                textColor: textColor,
              ),
            );
          } else {
            final List<Users> followersList = snapshot.data!;

            return ListView.builder(
              itemCount: followersList.length,
              itemBuilder: (context, index) {
                final user = followersList[index];
                final isLoading = _loadingStates[user.id!] ?? false;
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

