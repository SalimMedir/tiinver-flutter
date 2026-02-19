// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
// import '../../gloabal_key.dart';
// import '../../models/chatModel/chat_model.dart';
// import 'firebase_chat.dart';
//
// class FirebaseAccountHandling{
//
//   // var _signProvider = GlobalProviderAccess.signProvider;
//
//   FirebaseAccountHandling(this.signInProvider);
//
//   final SignInProvider signInProvider;
//
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//   // static FirebaseAuth get auth => FirebaseAuth.instance;
//   static SignInProvider? get user => GlobalProviderAccess.signProvider;
//   //static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
//
//   static ChatUser me = ChatUser(
//
//       id: user!.userId.toString(),
//       firstname: "",
//       email: user!.userEmail.toString(),
//       profile: "",
//       isActive: false,
//       // pushToken: ''
//   );
//
//   static Future<bool> userExists() async {
//     return (await firestore.collection('users').doc(user!.userId).get()).exists;
//   }
//
//   static Future<void> addChatUserToMyContact(BuildContext context, String contact) async {
//     await firestore.collection('users')
//         .where('id', isEqualTo: contact)
//         .get().then((value) async{
//       if(value.docs.isNotEmpty && value.docs.first.id != user!.userId) {
//         await firestore
//             .collection('users')
//             .doc(user!.userId)
//             .collection('myContacts')
//             .doc(value.docs.first.id)
//             .set({});
//         Navigator.pop(context);
//       }else{
//         Get.snackbar("Tiinver", "User Not Found");
//       }
//     },);
//   }
//
//   static Future<void> getSelfAccount() async {
//     await firestore.collection('users').doc(user!.userId).get().then((user) async {
//       if (user.exists) {
//         me = ChatUser.fromJson(user.data()!);
//         // await getFirebaseMessagingToken();
//         updateActiveStatus(true);
//       }
//     });
//   }
//
//   // static Future<void> getFirebaseMessagingToken() async {
//   //   await fMessaging.requestPermission();
//   //
//   //   await fMessaging.getToken().then((t) {
//   //     if (t != null) {
//   //       me.pushToken = t;
//   //     }
//   //   });
//   //   // for handling foreground messages
//   //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //   //   log('Got a message whilst in the foreground!');
//   //   //   log('Message data: ${message.data}');
//   //
//   //   //   if (message.notification != null) {
//   //   //     log('Message also contained a notification: ${message.notification}');
//   //   //   }
//   //   // });
//   // }
//
//   static Future<void> updateActiveStatus(bool isOnline) async {
//     firestore.collection('users').doc(user!.userId).update({
//       'isActive': isOnline,
//       'lastSeen': DateTime.now().millisecondsSinceEpoch.toString(),
//       // 'pushToken': me.pushToken,
//     });
//   }
//
//   static Future<List<ChatUser>> getMyContacts() async {
//     final contactDocs = await firestore
//         .collection('users')
//         .doc(user!.userId)
//         .collection('myContacts')
//         .get();
//
//     List<ChatUser> contacts = [];
//     for (var doc in contactDocs.docs) {
//       final contactData = await firestore.collection('users').doc(doc.id).get();
//       if (contactData.exists) {
//         contacts.add(ChatUser.fromJson(contactData.data()!));
//       } else if (doc['isGroup'] == true) {
//         final groupData = await firestore.collection('allGroups').doc(doc.id).get();
//         if (groupData.exists) {
//           contacts.add(ChatUser(
//             id: groupData['id'],
//             firstname: groupData['name'],
//             email: '',
//             profile: '',
//             isActive: false,
//             // pushToken: '',
//           ));
//         }
//       }
//     }
//     return contacts;
//   }
//
//   static Future<void> createGroupWithContacts(BuildContext context, String groupName, List<ChatUser> selectedContacts) async {
//
//     final signInProvider = Provider.of<SignInProvider>(context, listen: false);
//     FirebaseChat users = FirebaseChat(signInProvider);
//
//     List<String> memberUids = selectedContacts.map((contact) => contact.id).toList();
//     memberUids.add(user!.userId.toString()); // Add the current user to the group
//
//     await FirebaseChat.createGroup(groupName, memberUids);
//     Navigator.pop(context); // Close the group creation screen
//   }
//
// }