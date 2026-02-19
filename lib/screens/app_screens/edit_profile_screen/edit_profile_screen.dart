import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/images_path.dart';
import 'package:tiinver_project/widgets/header.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

import '../../../providers/profile/profile_provider.dart';
import '../../../providers/signIn/sign_in_provider.dart';
import 'comp/edit_profile_tile.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final signInP = Provider.of<SignInProvider>(context, listen: false);
    // Provider.of<UpdateProfileProvider>(context, listen: false).loadUserFromPreferences();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("", [], isIconShow: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 8.h,
                    backgroundColor: lightGreyColor,
                    backgroundImage: provider.userModel.profile != null ?
                    NetworkImage(provider.userModel.profile.toString())
                        : AssetImage(ImagesPath.profileImage),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: themeColor,
                        shape: BoxShape.circle
                    ),
                    child: Image.asset(ImagesPath.cameraIcon,color: bgColor,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Consumer<ProfileProvider>(builder: (context, value, child) {
              return Column(
                children: [
                  EditProfileTile(
                    image: ImagesPath.personIcon,
                    text: "Full Name",
                    hint: "Name",
                    controller: value.nameController,
                  ),
                  EditProfileTile(
                    image: ImagesPath.locationIcon,
                    text: "Location",
                    hint: "Location",
                    controller: value.locationController,
                  ),
                  EditProfileTile(
                    image: ImagesPath.businessIcon,
                    text: "Work at",
                    hint: "Work",
                    controller: value.workController,
                  ),
                  EditProfileTile(
                    image: ImagesPath.qualificationIcon,
                    text: "Qualification",
                    hint: "Qualification",
                    controller: value.qualificationController,
                  ),
                  EditProfileTile(
                    image: ImagesPath.educationIcon,
                    text: "School / Collage",
                    hint: "School / College",
                    controller: value.schoolController,
                  ),
                ],
              );
            },),
            Consumer<ProfileProvider>(builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  value.isLoading ?
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  )
                      : SubmitButton(
                      width: 40.w,
                      title: "Save",
                      press: (){

                        provider.updateProfile(
                            userApiKey: signInP.userApiKey.toString(),
                            id: signInP.userId.toString(),
                            name: provider.nameController.text,
                            qualification: provider.qualificationController.text,
                            workAt: provider.workController.text,
                            school: provider.schoolController.text,
                            location: provider.locationController.text
                        );

                      }
                  )
                ],
              );
            },)
          ],
        ),
      ),
    );
  }
}
