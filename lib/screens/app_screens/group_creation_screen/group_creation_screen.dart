import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/providers/createGroup/create_group_provider.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import 'package:tiinver_project/widgets/field_widget.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../constants/images_path.dart';
import '../../../providers/chat/chat_provider.dart';
import '../../../providers/connectedUsers/connected_users_provider.dart';
import '../../../widgets/image_loader_widget.dart';

class GroupCreationScreen extends StatefulWidget {
  GroupCreationScreen({super.key});

  @override
  State<GroupCreationScreen> createState() => _GroupCreationScreenState();
}

class _GroupCreationScreenState extends State<GroupCreationScreen> {

  String? _selectedValue;

  final List<String> _dropdownItems = [
    '100 coins',
    '200 coins',
    '400 coins',
    '500 coins',
    '700 coins',
    '800 coins',
    '1000 coins',
  ];



  String selectedValue = "Private";

  bool isCheck = false;

  void handleRadioValueChange(String value) {
    setState(() {
      selectedValue = value;
    });
  }

  void handleCheckBoxValueChange(bool val) {
    setState(() {
      isCheck = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    var groupCreationP = Provider.of<CreateGroupProvider>(context,listen: false);
    var signInP = Provider.of<SignInProvider>(context,listen: false);
    var chatP = Provider.of<ChatProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("Contacts",
          [
            SizedBox(
                width: 7.w,
                child: Image.asset(ImagesPath.menuIcon)),
            SizedBox(width: 15,),
          ],
          isIconShow: true, isCenterTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                  inputController: groupCreationP.groupC,
                bdRadius: 50,
                fillColor: lightGreyColor,
                hintText: "Group Name",
                prefixIcon: Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.all(15),
                  child: Image.asset(ImagesPath.cameraIcon),
                ),
              ),
              SizedBox(height: 20,),
              TextWidget1(text: "Type of Group", fontSize: 20.dp, fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
              Row(
                children: [
                  Radio(
                      value: "Private",
                      groupValue: selectedValue,
                      activeColor: themeColor,
                      toggleable: true,

                      onChanged: (value){
                        handleRadioValueChange(value.toString());
                      }
                  ),
                  TextWidget1(text: "Private", fontSize: 12.dp, fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                ],
              ),
              Row(
                children: [
                  Radio(
                      value: "Public",
                      groupValue: selectedValue,
                      activeColor: themeColor,
                      toggleable: true,

                      onChanged: (value){
                        handleRadioValueChange(value.toString());
                      }
                  ),
                  TextWidget1(text: "Public", fontSize: 12.dp, fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: isCheck,
                      onChanged: (value){
                        handleCheckBoxValueChange(value!);
                  }),
                  TextWidget1(text: "Group Pricing", fontSize: 12.dp, fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                ],
              ),
              if(isCheck) Column(
                children: [
                  TextWidget1(text: "Select the prize of the group", fontSize: 12.dp,
                      fontWeight: FontWeight.w600, isTextCenter: false, textColor: darkGreyColor),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 30.w,
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: DropdownButton<String>(
                      hint: Text('Select Prize',style: TextStyle(color: bgColor),),
                      dropdownColor: themeColor,
                      underline: SizedBox(),
                      isExpanded: true,
                      iconEnabledColor: bgColor,
                      style: TextStyle(
                        color: bgColor,
                      ),
                      value: _selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedValue = newValue;
                        });
                      },
                      items: _dropdownItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget1(text: "Invitation Link:", fontSize: 16.dp,
                      fontWeight: FontWeight.w600, isTextCenter: false, textColor: darkGreyColor),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 40.w,
                    child: TextWidget1(text: "http/tiinver.com.group/17789003", fontSize: 12.dp,
                        fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor,),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              TextWidget1(text: "Selected Member", fontSize: 20.dp,
                  fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
              ChangeNotifierProvider(
                create: (_) => ConnectedUsersProvider()..fetchConnectedUsers(context),
                child: Consumer<ConnectedUsersProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (provider.errorMessage != null) {
                      return Center(child: Text(provider.errorMessage!));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: provider.connectedUsers.length,
                      itemBuilder: (context, index) {
                        final user = provider.connectedUsers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            onTap: () async {
                              chatP.checkOrCreateChat(context, user);
                              // Get.to(()=>ChatScreen(
                              //   targetId: user.userId.toString() ?? '',
                              //   firstName: user.firstname ?? '',
                              //   profile: user.profile!,
                              //   userName: user.username ?? '',
                              //   senderId: signInP.userId.toString(),
                              //   chatId: '',
                              // ));

                              // FirebaseAccountHandling.addChatUserToMyContact(context, user.userId.toString());
                              // debugPrint(user.userId.toString());
                              // if (user.userId != null) {
                              //   String chatId = await Provider.of<ChatProvider>(context, listen: false)
                              //       .createChat(signInP.userId.toString(), user.userId.toString());
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => ChatScreen(
                              //       chatId: chatId,
                              //       senderId: signInP.userId.toString(),
                              //       receiverId: user.userId.toString(),
                              //     )),
                              //   );
                              // }
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: ImageLoaderWidget(imageUrl: user.profile!),
                              ),
                            ),
                            title: TextWidget1(text: "${user.firstname} ${user.lastname}", fontSize: 16.dp,
                                fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
                            subtitle: TextWidget1(text: user.username ?? '', fontSize: 12.dp,
                                fontWeight: FontWeight.w600, isTextCenter: false, textColor: darkGreyColor),
                          ),
                        );
                      },);
                  },
                ),
              ),

              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: 20,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 8.0),
              //       child: ListTile(
              //         leading: CircleAvatar(
              //           radius: 3.5.h,
              //           backgroundImage: AssetImage(ImagesPath.profileImage),
              //         ),
              //         title: TextWidget1(text: "Alexandra", fontSize: 16.dp,
              //             fontWeight: FontWeight.w600, isTextCenter: false, textColor: themeColor),
              //         subtitle: TextWidget1(text: "Alex@73456", fontSize: 12.dp,
              //             fontWeight: FontWeight.w600, isTextCenter: false, textColor: darkGreyColor),
              //       ),
              //     );
              //   },),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset(ImagesPath.sendIcon,color: bgColor),
          ),
          onPressed: (){
            groupCreationP.createGroup(
                creatorId: signInP.userId,
                userApiKey: signInP.userApiKey,
                groupType: selectedValue);
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupChatScreen()));
          }
      ),
    );
  }
}
