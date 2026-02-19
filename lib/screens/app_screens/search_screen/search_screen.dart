import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/images_path.dart';
import 'package:tiinver_project/providers/profile/profile_provider.dart';
import 'package:tiinver_project/providers/search/search_provider.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import 'package:tiinver_project/screens/app_screens/other_user_profile_screen/other_user_profile_screen.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../models/searchModel/search_model.dart';
import 'comp/searching_tile.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final Map<int, bool> _loadingStates = {};

  @override
  Widget build(BuildContext context) {
    var signInP = Provider.of<SignInProvider>(context,listen: false);
    var profileP = Provider.of<ProfileProvider>(context,listen: false);
    var searchP = Provider.of<SearchProvider>(context,listen: false);

    searchP.searchUsers(userApiKey: signInP.userApiKey.toString());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("", [
        SizedBox(
          width: 70.w,
          child: TextFormField(
            onChanged: (value){
              if(searchP.searchC.text.isNotEmpty){
                searchP.searchUsers(userApiKey: signInP.userApiKey.toString());
              }
            },
            validator: (value) {
              if(value!.isEmpty){
                return "Enter the Field";
              }else{
                return null;
              }
            },
            maxLines: 1,
            textInputAction: TextInputAction.done,
            autofocus: true,
            style: TextStyle(
              fontSize: 12.dp,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: themeColor,
            controller: searchP.searchC,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              prefixIcon: Container(
                     padding: EdgeInsets.all(14),
                       width: 4.w,
                       child: Image.asset(ImagesPath.searchingIcon,color: themeColor,fit: BoxFit.cover,)),
              suffixIcon: IconButton(
                       onPressed: (){
                         searchP.clearSearch();
                       },
                       icon: Icon(Icons.cancel,color: themeColor,)),
              suffixIconColor: darkGreyColor,
              hintText: "Search",
              hintStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              fillColor: tileColor,
              filled: true,
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderSide:  BorderSide(
                  color: tileColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:  BorderSide(
                  color: tileColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(
                  color: tileColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          )
        ),
        SizedBox(width: 10,),
        SizedBox(
            width: 7.w,
            child: Image.asset(ImagesPath.menuIcon)),
        SizedBox(width: 10,),
      ],
          isIconShow: true),
      body: Expanded(
        child: StreamBuilder<List<SearchUsers>>(
          stream: searchP.searchStream,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No results found'));
            } else {
              final List<SearchUsers> users = snapshot.data!;


              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final isLoading = searchP.isLoadingForUser(user.id!);
                  return InkWell(
                    onTap: () {
                      profileP.clearList();
                      Get.to(() => OtherUserProfileScreen(userId: user.id!));
                    },
                    child: Consumer<SearchProvider>(builder: (context, value, child) {
                      return SearchingTile(
                        name: user.firstname ?? '',
                        userName: user.username ?? '',
                        buttonText: user.isFollowed! ? "following" : "follow",
                        buttonAction: () async {
                          await profileP.follow(
                            followId: signInP.userId.toString(),
                            userId: user.id.toString(),
                            userApiKey: signInP.userApiKey.toString(),
                          );
                          value.searchUsers(userApiKey: signInP.userApiKey.toString());

                        },
                        imageUrl: user.profile.toString(),
                        isLoading: isLoading,
                      );
                    },),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
