// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:tiinver_project/constants/colors.dart';
// import 'package:tiinver_project/constants/images_path.dart';
// import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
// import 'package:tiinver_project/screens/app_screens/graphicScreen/graphic_screen.dart';
// import 'package:tiinver_project/widgets/image_loader_widget.dart';
// import '../../../firebase/chat/firebase_account_handling.dart';
// import '../../../firebase/chat/firebase_chat.dart';
// import '../../../models/chatModel/chat_model.dart';
//
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../../models/msgModel/msg_model.dart';
// import '../../../providers/chatActivityProvider/chat_activity_provider.dart';
// import '../../../providers/uploadingProgressProvider/uploading_progress_provider.dart';
// import '../../auth_screens/onboarding_screen/comp/navigate_button.dart';
// import '../chat_home_screen/comp/date_util.dart';
// import 'comp/chat_message_card.dart';
//
// class ChatScreen extends StatefulWidget {
//   final ChatUser user;
//   const ChatScreen({super.key, required this.user});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   FlutterSoundRecorder? soundRecorder;
//   FlutterSoundPlayer? soundPlayer;
//   String? _audioPath;
//   List<Message> _list = [];
//   TextEditingController userTextController = TextEditingController();
//   bool isCameraVisible = true;
//   String userDocumentId = '';
//   FocusNode _focusNode = FocusNode();
//
//
//   @override
//   void initState()  {
//     super.initState();
//     soundRecorder = FlutterSoundRecorder();
//     soundPlayer = FlutterSoundPlayer();
//     _initializeRecorder();
//     _initializePlayer();
//     SystemChannels.lifecycle.setMessageHandler((message) {
//       if (FirebaseChat.user!.userId != null) {
//         if (message.toString().contains('resume')) {
//           FirebaseAccountHandling.updateActiveStatus(true);
//         }
//         if (message.toString().contains('pause')) {
//           FirebaseAccountHandling.updateActiveStatus(false);
//         }
//       }
//       return Future.value(message);
//     });
//   }
//
//   @override
//   void dispose() {
//     soundRecorder!.closeRecorder();
//     soundPlayer!.closePlayer();
//     super.dispose();
//     SystemChannels.lifecycle.setMessageHandler((message) {
//       if (FirebaseChat.user!.userId != null) {
//         if (message.toString().contains('resume')) {
//           FirebaseAccountHandling.updateActiveStatus(true);
//         }
//         if (message.toString().contains('pause')) {
//           FirebaseAccountHandling.updateActiveStatus(false);
//         }
//       }
//       return Future.value(message);
//     });
//   }
//
//   Future<void> _initializeRecorder() async {
//     await soundRecorder?.openRecorder();
//   }
//
//   Future<void> _initializePlayer() async {
//     await soundPlayer?.openPlayer();
//   }
//
//
//   Future<void> _startRecording() async {
//     try {
//       var status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         throw RecordingPermissionException('Microphone permission not granted');
//       }
//
//       Directory tempDir = await getTemporaryDirectory();
//       _audioPath = '${tempDir.path}/flutter_sound.aac';
//
//       await soundRecorder?.startRecorder(
//         toFile: _audioPath,
//         codec: Codec.aacADTS,
//       );
//     } catch (e) {
//       print('Error starting recording: $e');
//     }
//   }
//
//   Future<void> _stopRecording() async {
//     try {
//       _audioPath = await soundRecorder?.stopRecorder();
//     } catch (e) {
//       print('Error stopping recording: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // var chatEmojiProvider = Provider.of<ChatActivityEmojiProvider>(context, listen: false);
//     var chatSendButtonProvider = Provider.of<ChatActivitySendButtonProvider>(context, listen: false);
//     var signInProvider = Provider.of<SignInProvider>(context, listen: false);
//     var uploadingProgressBarProvider = Provider.of<UploadingProgressBarProvider>(context, listen: false);
//
//     final firebaseAccountHandling = FirebaseAccountHandling(signInProvider);
//
//     return GestureDetector(
//       onTap: FocusScope.of(context).unfocus,
//       child: Scaffold(
//         backgroundColor: bgColor,
//         appBar: AppBar(
//           backgroundColor: bgColor,
//           surfaceTintColor: bgColor,
//           toolbarHeight: 8.0.h,
//           automaticallyImplyLeading: false,
//           flexibleSpace: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('users')
//                 .where('id', isEqualTo: widget.user.id)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               final data = snapshot.data?.docs;
//               final list =
//                   data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
//               return Container(
//                 margin: EdgeInsets.only(top: 4.0.h),
//                 child: Row(
//                   children: [
//                     // IconButton(
//                     //     onPressed: () => Navigator.pop(context),
//                     //     icon: const Icon(Icons.arrow_back)),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 10),
//                       child: GestureDetector(
//                           onTap: (){
//                             Get.back();
//                           },
//                           child: NavigateButton(
//                             icon: CupertinoIcons.back,
//                             height: 30,
//                             width: 30,
//                             iconSize: 6.w,)),
//                     ),
//                     InkWell(
//                       onTap: () {},
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(50),
//                         child: CircleAvatar(
//                           radius: 3.h,
//                           child:ImageLoaderWidget(
//                             imageUrl: list.isNotEmpty
//                             ? list[0].profile
//                             : widget.user.profile,
//                       ),),),
//                     ),
//                     const SizedBox(width: 10),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           width: 65.0.w,
//                           child: Text(
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             list.isNotEmpty
//                                 ? list[0].firstname
//                                 : widget.user.firstname,
//                             style: TextStyle(
//                                 fontSize: 13.0.sp,
//                                 color: textColor,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           list.isNotEmpty
//                               ? list[0].isActive
//                               ? 'Online'
//                               : MyDateUtil.getLastActiveTime(
//                               context: context,
//                               lastActive: list[0].isActive.toString())
//                               : MyDateUtil.getLastActiveTime(
//                               context: context,
//                               lastActive: widget.user.isActive.toString()),
//                           style: TextStyle(
//                             fontSize: 10.0.sp,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//           actions: [
//             Container(
//                 padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//                 height: 8.h,
//                 child: Image.asset(ImagesPath.editIcon)),
//             Container(
//                 padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//                 height: 8.h,
//                 child: Image.asset(ImagesPath.phoneIcon)),
//             Container(
//                 padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//                 height: 8.h,
//                 child: Image.asset(ImagesPath.menuIcon)),
//             SizedBox(width: 10,),
//           ],
//         ),
//         body: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 child: StreamBuilder(
//                   stream: FirebaseChat.getAllMessages(widget.user),
//                   builder: (context, snapshot) {
//                     switch (snapshot.connectionState) {
//                       case ConnectionState.waiting:
//                       case ConnectionState.none:
//                         return const SizedBox();
//                       case ConnectionState.active:
//                       case ConnectionState.done:
//                         final data = snapshot.data?.docs;
//                         _list = data
//                             ?.map((e) => Message.fromJson(e.data()))
//                             .toList() ??
//                             [];
//                         if (_list.isNotEmpty) {
//                           return ListView.builder(
//                             reverse: true,
//                             itemCount: _list.length,
//                             padding: EdgeInsets.only(top: 1.0.h),
//                             physics: const BouncingScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               return MessageCard(message: _list[index]);
//                             },
//                           );
//                         } else {
//                           return Center(
//                             child: Text('Say Hii! 👋',
//                                 style: TextStyle(fontSize: 15.0.sp)),
//                           );
//                         }
//                     }
//                   },
//                 ),
//               ),
//               Consumer<UploadingProgressBarProvider>(
//                 builder: (context, value, child) {
//                   return value.isUploading
//                       ? const Align(
//                     alignment: Alignment.centerRight,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 20),
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   )
//                       : const SizedBox();
//                 },
//               ),
//               Padding(
//                 padding:
//                 EdgeInsets.symmetric(vertical: 0.7.h, horizontal: 2.0.w),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Card(
//                         color:
//                         bgColor,
//                         shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(15))),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 style: TextStyle(
//                                   color: textColor,
//                                   decorationColor: Colors.transparent,
//                                 ),
//                                 controller: userTextController,
//                                 keyboardType: TextInputType.multiline,
//                                 maxLines: null,
//                                 onTap: () async {
//                                   // if (chatEmojiProvider.isOpen) {
//                                   //   _focusNode.unfocus();
//                                   //   await chatEmojiProvider.setVisibility();
//                                   //   await Future.delayed(const Duration(milliseconds: 200));
//                                   //   _focusNode.requestFocus();
//                                   // }
//                                 },
//                                 onChanged: (value) {
//                                   if (chatSendButtonProvider.isTextButton && value.isNotEmpty) {
//                                     chatSendButtonProvider.setVisibility();
//                                   } else if (!chatSendButtonProvider.isTextButton && value.isEmpty) {
//                                     chatSendButtonProvider.setVisibility();
//                                   }
//                                 },
//                                 focusNode: _focusNode,
//                                 autofocus: false,
//                                 decoration: InputDecoration(
//                                   hintText: 'Type Something...',
//                                   filled: true,
//                                   fillColor: bgColor,
//                                   hintStyle: TextStyle(
//                                     color: textColor,
//                                     fontSize: 12.0.sp,
//                                     fontWeight: FontWeight.w300,
//                                   ),
//                                   border: InputBorder.none,
//                                   enabledBorder: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Get.to(()=>GraphicScreen(
//                                   user: widget.user,
//                                   isCamera: false,
//                                 ));
//                               },
//                               child: SizedBox(
//                                 child: Image.asset(ImagesPath.editIcon,height: 3.h,),
//                               ),
//                             ),
//                             SizedBox(width: 10,),
//                             InkWell(
//                               onTap: ()async{
//                                 final ImagePicker picker = ImagePicker();
//                                 final List<XFile> images =
//                                     await picker.pickMultiImage(
//                                     imageQuality: 70);
//                                 for (var i in images) {
//                                   uploadingProgressBarProvider.setVisibility(true);
//                                   await FirebaseChat.sendChatImage(_list, widget.user, File(i.path));
//                                   await uploadingProgressBarProvider.setVisibility(false);
//                                 }
//                               },
//
//                               child: SizedBox(
//                                 child: Image.asset(ImagesPath.galleryIcon,height: 3.h,),
//                               ),
//                             ),
//                             SizedBox(width: 15,),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Consumer<ChatActivitySendButtonProvider>(
//                       builder: (context, value, child) {
//                         return MaterialButton(
//                           onLongPress: () async {
//                             if (value.isTextButton && !value.isVisible) {
//                               _focusNode.unfocus();
//                               await value.animationVisibility(true);
//                               await _startRecording();
//                             } else if (value.isTextButton && value.isVisible) {
//                               _focusNode.unfocus();
//                               await value.animationVisibility(false);
//                               await _stopRecording();
//                               if(_audioPath != null && _audioPath!.isNotEmpty) {
//                                 await uploadingProgressBarProvider.setVisibility(true);
//                                 await FirebaseChat.sendChatVoiceMessage(_list, widget.user, _audioPath!);
//                                 await uploadingProgressBarProvider.setVisibility(false);
//                               }
//                             }
//                           },
//                           onPressed: () async {
//                             if (value.isTextButton && value.isVisible) {
//                               _focusNode.unfocus();
//                               await value.animationVisibility(false);
//                               await _stopRecording();
//                               if(_audioPath != null && _audioPath!.isNotEmpty) {
//                                 await uploadingProgressBarProvider.setVisibility(true);
//                                 await FirebaseChat.sendChatVoiceMessage(_list, widget.user, _audioPath!);
//                                 await uploadingProgressBarProvider.setVisibility(false);
//                               }
//                             }
//                             else if (userTextController.text.isNotEmpty) {
//                               if (_list.isEmpty) {
//                                 FirebaseChat.sendFirstMessage(widget.user, userTextController.text, Type.text);
//                               } else {
//                                 FirebaseChat.sendMessage(widget.user, userTextController.text, Type.text);
//                               }
//                               userTextController.text = '';
//                             }
//                           },
//                           minWidth: 0.0,
//                           padding: EdgeInsets.only(
//                             left: value.isVisible ? 0.0.h : 8.5,
//                             top: value.isVisible ? 0.0 : 8.5,
//                             bottom: value.isVisible ? 1.0.h : 8.5,
//                             right: value.isVisible ? 1.0.h : 8.5,
//                           ),
//                           shape: const CircleBorder(),
//                           color: themeColor,
//                           child: value.isTextButton
//                               ? value.isVisible
//                               ? ClipRect(
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Transform.scale(
//                                 scale: 4.0,
//                                 child: SizedBox(
//                                   height: 7.0.h,
//                                   width: 7.0.h,
//                                   child: Lottie.asset(
//                                     'lottie/lottie_mic.json',
//                                     repeat: true,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                               : const Icon(
//                             Icons.mic,
//                             color: Colors.white,
//                             size: 28.0,
//                           )
//                               : const Icon(
//                             Icons.send,
//                             color: Colors.white,
//                             size: 28.0,
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               // Consumer<ChatActivityEmojiProvider>(builder: (context, value, child) {
//               //   return value.isOpen
//               //       ? SizedBox(
//               //     height: 35.0.h,
//               //     child: EmojiPicker(
//               //       textEditingController: userTextController,
//               //       onBackspacePressed: () {
//               //         if(!chatSendButtonProvider.isTextButton && userTextController.text.isEmpty) {
//               //           chatSendButtonProvider.setVisibility();
//               //         }
//               //       },
//               //       onEmojiSelected: (category, emoji) {
//               //         if (chatSendButtonProvider.isTextButton && userTextController.text.isNotEmpty) {
//               //           chatSendButtonProvider.setVisibility();
//               //         }
//               //       },
//               //       config: const Config(),
//               //     ),
//               //   )
//               //       : const SizedBox(height: 0.0, width: 0.0);
//               // },),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/images_path.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/gloabal_key.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import 'package:tiinver_project/screens/auth_screens/onboarding_screen/comp/navigate_button.dart';
import 'package:tiinver_project/widgets/image_loader_widget.dart';
import '../../../DatabaseHelper/database_helper.dart';
import '../../../providers/chat/chat_provider.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String otherUserId;
  final String otherUserFirstName;
  final String otherUserProfile;
  final String otherUserUserName;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.otherUserId,
    required this.otherUserFirstName,
    required this.otherUserProfile,
    required this.otherUserUserName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late IO.Socket _socket;
  // final TextEditingController _messageController = TextEditingController();
  // bool _isRecording = false;
  // String? _voiceMessagePath;
  late ChatProvider _chatProvider;
  late SignInProvider _signProvider;
  Database? database;
  final DatabaseHelper _dbHelper = DatabaseHelper();



  void _connectSocket() {
    _socket = IO.io('https://api.tiinver.com:2020', IO.OptionBuilder()
        .setTransports(['websocket'])
        .build()
    );  

    _socket.onConnect((_) {
      log('Connected to Socket.IO server');
    });

    _socket.on('message', (data) {
      var message = jsonDecode(data);
      log('Received message: $message');
    });

    _sendMessage();
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
    _signProvider = Provider.of<SignInProvider>(context,listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    await _chatProvider.getMessages(widget.chatRoomId);
  }

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('HH:mm').format(timestamp);
  }

  Future<void> playAudio(String filePath) async {
    final player = AudioPlayer();
    await player.play(DeviceFileSource(filePath));
  }

  @override
  Widget build(BuildContext context) {

    var chatP = Provider.of<ChatProvider>(context,listen: false);
    var signP = Provider.of<SignInProvider>(context,listen: false);
    final userUID =  GlobalProviderAccess.signProvider!.userId.toString();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: Get.back,
              child: NavigateButton(
                icon: CupertinoIcons.back,
                height: 30,
                width: 30,
                iconSize: 6.w,),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: ImageLoaderWidget(imageUrl: widget.otherUserProfile),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30.w,
                    child: TextWidget1(
                        text: widget.otherUserFirstName, fontSize: 16,
                        fontWeight: FontWeight.bold, isTextCenter: false, textColor: textColor),
                  ),
                  SizedBox(
                    width: 30.w,
                    child: TextWidget1(
                        text: widget.otherUserUserName, fontSize: 12,
                        fontWeight: FontWeight.w500, isTextCenter: false, textColor: textColor),
                  ),
                ],
              ),
              Image.asset(ImagesPath.editIcon,height: 30,),
              Image.asset(ImagesPath.phoneIcon,height: 30,),
              Image.asset(ImagesPath.menuIcon,height: 30,),
            ],
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return FutureBuilder(
                  future: chatProvider.getMessages(widget.chatRoomId),
                  builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No messages yet.'));
                    }

                    final messages = snapshot.data!;
                    // Controller to manage scrolling
                    final ScrollController scrollController = ScrollController();

                    // Scroll to the bottom when new messages are added
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        scrollController.jumpTo(scrollController.position.maxScrollExtent);
                      }
                    });

                    return ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      reverse: false, // Show latest message at the bottom
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message['sender_id'] == userUID; // Replace with actual user ID
                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: MessageBubble(
                            text: message['message'],
                            timestamp: Timestamp.fromMillisecondsSinceEpoch(message['timestamp']),
                            isSender: isMe,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatP.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (text) {
                      // chatP.isText();

                      // setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Consumer<ChatProvider>(builder: (context, value, child) {
                  return value.messageController.text.isEmpty
                      ? GestureDetector(
                        onLongPress: value.startRecording,
                        onTap: value.stopRecording,
                         child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                          color: themeColor,
                          shape: BoxShape.circle
                      ),
                         child: Icon(
                               value.isRecording ? Icons.stop : Icons.mic,
                             color: value.isRecording ? bgColor : bgColor,
                      ),
                    ),
                  )
                      : IconButton(
                        icon: Icon(Icons.send),
                         onPressed: _sendMessage,
                  );
                },)
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _sendMessage() async {
    final message = _chatProvider.messageController.text;
    // if (message.isNotEmpty) {
    //   _chatProvider.sendMessage(
    //       widget.chatRoomId,
    //       _signProvider.userId.toString(),
    //       _chatProvider.voiceMessagePath.toString(),
    //       _chatProvider.messageController.text.toString(),
    //       widget.otherUserId,
    //       widget.otherUserFirstName
    //   ).whenComplete(() {
    //     // setState(() async {
    //     //
    //     //   // _messageController.clear();
    //     // });
    //   },);
    //   await _dbHelper.updateLastMessage(
    //     widget.chatRoomId,
    //     _chatProvider.messageController.text.toString(),
    //   );
    //   _chatProvider.messageController.clear();
    //   // Save text message to database and send it
    //   print('Send message: $message');
    //   // _messageController.clear();
    // }
    // else if (_chatProvider.voiceMessagePath != null) {
    //   _chatProvider.sendMessage(
    //       widget.chatRoomId,
    //       _signProvider.userId.toString(),
    //       _chatProvider.voiceMessagePath.toString(),
    //       _chatProvider.messageController.text.toString(),
    //       widget.otherUserId,
    //       widget.otherUserFirstName
    //   ).whenComplete(() {
    //     // setState(() async {
    //     //   await _dbHelper.updateLastMessage(
    //     //     widget.chatRoomId,
    //     //     _messageController.text.toString(),
    //     //   );
    //     //   // _messageController.clear();
    //     // });
    //   },);
    //   await _dbHelper.updateLastMessage(
    //     widget.chatRoomId,
    //     _chatProvider.messageController.text.toString(),
    //   );
    //   _chatProvider.messageController.clear();
    //   // Save voice message to database and send it
    //   print('Send voice message: ${_chatProvider.voiceMessagePath}');
    //   // _chatProvider.voiceMessagePath = null; // Clear the path after sending
    // }


    // _chatProvider.loadChatRooms();
  }
}

// Align(
// alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
// child: Container(
// margin: EdgeInsets.symmetric(vertical: 5),
// constraints: BoxConstraints(maxWidth: 60.w),
// padding: EdgeInsets.all(10),
// decoration: BoxDecoration(
// color: isMe ? themeColor : Colors.grey[300],
// borderRadius: BorderRadius.circular(10),
// ),
// child: Column(
// children: [
// Align(
// alignment: Alignment.topRight,
// child: Text(
// message['message'],
// style: TextStyle(color: isMe ? Colors.white : Colors.black),
// ),
// ),
// Align(
// alignment: FractionalOffset.bottomRight,
// child: Text(
// formatTimestamp(
// DateTime.fromMillisecondsSinceEpoch(
// message['timestamp'])).toString(),
// style: TextStyle(color: isMe ? Colors.white : Colors.black),
// ),
// ),
// ],
// ),
// ),
// )



// import 'package:flutter/material.dart';
// import 'package:flutter_sizer/flutter_sizer.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:tiinver_project/constants/text_widget.dart';
// import 'package:tiinver_project/providers/profile/profile_provider.dart';
// import 'package:tiinver_project/widgets/header.dart';
// import '../../../SocketIO/socket_io.dart';
// import '../../../constants/colors.dart';
// import '../../../constants/images_path.dart';
// import '../../../models/chatModel/chat_model.dart';
// import '../../../providers/chat/chat_provider.dart';
// import '../../../routes/routes_name.dart';
// import '../../../widgets/field_widget.dart';
// import '../../../widgets/image_loader_widget.dart';
//
// class ChatScreen extends StatelessWidget {
//   final String senderId;
//   final String chatId;
//   final String targetId;
//   final String firstName;
//   final String userName;
//   final String profile;
//
//   const ChatScreen({super.key,
//     required this.senderId,
//     required this.chatId,
//     required this.targetId,
//     required this.firstName,
//     required this.userName,
//     required this.profile,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final chatProvider = Provider.of<ChatProvider>(context, listen: false);
//     final msgC = TextEditingController();
//
//     var profileP = Provider.of<ProfileProvider>(context,listen: false);
//
//     return Scaffold(
//       appBar: Header().header1(
//           "",
//           [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: bgColor,
//                   border: Border.all(
//                       color: themeColor,
//                       width: 2.dp
//                   )
//               ),
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundImage: NetworkImage(profile),
//               ),
//               // ClipRRect(
//               //     borderRadius: BorderRadius.circular(100),
//               //     child:
//                   // Container(
//                   //   padding: EdgeInsets.all(10),
//                   //   height: 60,width: 60,
//                   //   decoration: BoxDecoration(
//                   //       shape: BoxShape.circle,
//                   //       color: lightGreyColor
//                   //   ),
//                   //   child: ImageLoaderWidget(imageUrl: profileP.userModel.profile.toString()),
//                   // )
//               // ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                     width: 35.w,
//                     child: TextWidget1(text: firstName, fontSize: 16.dp, fontWeight: FontWeight.w800, isTextCenter: false, textColor: textColor)),
//                 SizedBox(
//                     width: 35.w,
//                     child: TextWidget1(text: userName, fontSize: 14.dp, fontWeight: FontWeight.w500, isTextCenter: false, textColor: textColor)),
//               ],
//             ),
//             Image.asset(ImagesPath.editIcon,height: 30,),
//             SizedBox(width: 10,),
//             Image.asset(ImagesPath.phoneIcon,height: 30,),
//             SizedBox(width: 10,),
//             Image.asset(ImagesPath.menuIcon,height: 30,),
//             SizedBox(width: 10,),
//           ],
//         ),
//       ],
//           isIconShow: true),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               height: 78.h,
//               width: 100.w,
//               color: lightGreyColor,
//               child: ListView.builder(
//                 reverse: true,
//                 shrinkWrap: true,
//                 itemCount: 20,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: EdgeInsets.all(20),
//                     width: 80.w,
//                     height: 10.h,
//                     color: bgColor,
//                   );
//                 },
//               ),
//             ),
//           ),
//           Container(
//             color: tileColor,
//             padding: EdgeInsets.only(bottom: 0),
//             width: 100.w,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                     width: 65.w,
//                     child: InputField(
//                       inputController: msgC,
//                       hintText: "messag...",
//                       bdRadius: 0,
//                     )),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Get.toNamed(RoutesName.graphicScreen);
//                       },
//                       child: Container(
//                           padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//                           height: 8.h,
//                           child: Image.asset(msgC.text.isEmpty ? ImagesPath.editIcon : ImagesPath.voiceIcon)),
//                     ),
//                     Container(
//                         padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//                         height: 8.h,
//                         child: Image.asset(ImagesPath.galleryIcon)),
//                     InkWell(
//                       onTap: () {
//                         // msgP.sendPrivateMsg(
//                         //     msg: msgC.text.toString(),
//                         //     from: profileP.userModel.username.toString(),
//                         //     to: "40_",
//                         //     userApiKey: signInP.userApiKey.toString(),
//                         //     msgSize: '10kb'
//                         // );
//                       },
//                       child: Container(
//                           padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
//                           height: 8.h,
//                           child: Image.asset(ImagesPath.sendIcon)),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatScreen extends StatelessWidget {
//   final String chatId;
//   final String senderId;
//   final String receiverId;
//
//   const ChatScreen({
//     super.key,
//     required this.chatId,
//     required this.senderId,
//     required this.receiverId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ChatProvider(),
//       child: Scaffold(
//         backgroundColor: bgColor,
//         appBar: AppBar(
//           title: Text("UserProfile(receiverId: receiverId)"),
//           backgroundColor: bgColor,
//           surfaceTintColor: bgColor,
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: MessageList(chatId: chatId, senderId: senderId),
//             ),
//             // MessageInput(chatId: chatId, senderId: senderId),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class MessageList extends StatelessWidget {
//   final String chatId;
//   final String senderId;
//
//   const MessageList({
//     super.key,
//     required this.chatId,
//     required this.senderId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column();
//   }
// }
//
// Consumer<ChatProvider>(
//       builder: (context, provider, child) {
//         return StreamBuilder<QuerySnapshot>(
//           stream: provider.getMessages(chatId),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//
//             var messages = snapshot.data!.docs;
//             return ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 var message = messages[index];
//                 bool isSender = message['senderId'] == senderId;
//                 return Align(
//                   alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//                   child: MessageBubble(
//                     text: message['text'],
//                     timestamp: message['timestamp'],
//                     isSender: isSender,
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     )
//
class MessageBubble extends StatelessWidget {
  final String text;
  final Timestamp timestamp;
  final bool isSender;

  const MessageBubble({
    super.key,
    required this.text,
    required this.timestamp,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: isSender ? themeColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(color: isSender ? Colors.white : Colors.black),
          ),
          SizedBox(height: 5),
          Text(
            _formatTimestamp(timestamp),
            style: TextStyle(color: isSender ? Colors.white : Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate();
    return "${date.hour}:${date.minute} ${date.hour > 11 ? 'PM' : 'AM'}";
  }
}
//
// class MessageInput extends StatelessWidget {
//   final String chatId;
//   final String senderId;
//   final TextEditingController _controller = TextEditingController();
//
//   MessageInput({required this.chatId, required this.senderId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: tileColor,
//       padding: EdgeInsets.only(bottom: 0),
//       width: 100.w,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 65.w,
//             child: InputField(
//               inputController: _controller,
//               hintText: "Message...",
//               bdRadius: 0,
//             ),
//           ),
//           Row(
//             children: [
//               InkWell(
//                 onTap: () {
//                   Get.toNamed(RoutesName.graphicScreen);
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
//                   height: 8.h,
//                   child: Image.asset(
//                     _controller.text.isEmpty ? ImagesPath.editIcon : ImagesPath.voiceIcon,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
//                 height: 8.h,
//                 child: Image.asset(ImagesPath.galleryIcon),
//               ),
//               InkWell(
//                 onTap: () {
//                   Provider.of<ChatProvider>(context, listen: false)
//                       .sendMessage(chatId, senderId, _controller.text);
//                   _controller.clear();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
//                   height: 8.h,
//                   child: Image.asset(ImagesPath.sendIcon),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   // Record voice message
//   void startRecording() {
//     RecordMp3.instance.start('path_to_save_audio.mp3', (type) {
//       // Handle callback
//     });
//   }
//
//   void stopRecording() {
//     bool isRecordingStopped = RecordMp3.instance.stop();
//     if (isRecordingStopped) {
//       // Upload audio file to Firestore or a storage service and get the URL
//       // Send the audio URL as a message
//     }
//   }
//
//   // Play voice message
//   void playAudio(String url) {
//     AudioPlayer audioPlayer = AudioPlayer();
//     audioPlayer.play(UrlSource(url));
//   }
//
//   void pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       File file = File(result.files.single.path!);
//       // Upload file to Firestore or a storage service and get the URL
//       // Send the file URL as a message
//     }
//   }
// }
//
// class UserProfile extends StatelessWidget {
//   final String receiverId;
//
//   UserProfile({required this.receiverId});
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<DocumentSnapshot>(
//       future: Provider.of<ChatProvider>(context, listen: false).getUserDetails(receiverId),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//
//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return Text('User not found');
//         }
//
//         var user = snapshot.data!.data() as Map<String, dynamic>?;
//
//         if (user == null) {
//           return Text('User data is null');
//         }
//
//         var isActive = user['isActive'];
//         var lastSeen = user['lastSeen'].toDate();
//
//         return Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: NetworkImage(user['profile']),
//             ),
//             SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user['username'],
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   isActive ? 'Active now' : 'Last seen: ${_formatTimestamp(lastSeen)}',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   String _formatTimestamp(DateTime timestamp) {
//     var now = DateTime.now();
//     var difference = now.difference(timestamp);
//
//     if (difference.inMinutes < 1) {
//       return 'just now';
//     } else if (difference.inMinutes < 60) {
//       return '${difference.inMinutes} minutes ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours} hours ago';
//     } else {
//       return '${difference.inDays} days ago';
//     }
//   }
// }









