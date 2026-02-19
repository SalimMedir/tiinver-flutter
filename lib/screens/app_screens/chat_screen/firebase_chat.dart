// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart';
// import '../../../models/chatModel/chat_model.dart';
// import 'package:path/path.dart' as path;
//
//
// class FirebaseChat {
//   static FirebaseAuth get auth => FirebaseAuth.instance;
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//   static FirebaseStorage storage = FirebaseStorage.instance;
//   static User get user => auth.currentUser!;
//
//   static Future<void> sendPushNotification(ChatUser chatUser, String msg) async {
//     // try {
//     //   final body = {
//     //     "message": {
//     //       "token": chatUser.pushToken,
//     //       "notification": {
//     //         "title": me.name, //our name should be send
//     //         "body": msg,
//     //       },
//     //     }
//     //   };
//     //
//     //   // Firebase Project > Project Settings > General Tab > Project ID
//     //   const projectID = 'dummy--chat';
//     //
//     //   // get firebase admin token
//     //   final bearerToken = await NotificationAccessToken.getToken;
//     //
//     //   log('bearerToken: $bearerToken');
//     //
//     //   // handle null token
//     //   if (bearerToken == null) return;
//     //
//     //   var res = await post(
//     //     Uri.parse(
//     //         'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
//     //     headers: {
//     //       HttpHeaders.contentTypeHeader: 'application/json',
//     //       HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
//     //     },
//     //     body: jsonEncode(body),
//     //   );
//     //
//     //   log('Response status: ${res.statusCode}');
//     //   log('Response body: ${res.body}');
//     // } catch (e) {
//     //   log('\nsendPushNotificationE: $e');
//     // }
//   }
//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getMyContactsUid() {
//     return firestore
//         .collection('userAccount')
//         .doc(user.uid)
//         .collection('myContacts')
//         .snapshots();
//   }
//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> userIds) {
//     return firestore
//         .collection('userAccount')
//         .where('userUid',
//         whereIn: userIds.isEmpty
//             ? ['']
//             : userIds)
//         .snapshots();
//   }
//
//   static Future<void> sendFirstMessage(ChatUser chatUser, String msg, Type type) async {
//     await firestore
//         .collection('userAccount')
//         .doc(chatUser.userUid)
//         .collection('myContacts')
//         .doc(user.uid)
//         .set({}).then((value) => sendMessage(chatUser, msg, type));
//   }
//
//   static String getConversationID(String id) {
//     return user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';
//   }
//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
//     return firestore
//         .collection('allChats/${getConversationID(user.userUid)}/userMessages/')
//         .orderBy('sent', descending: true)
//         .snapshots();
//   }
//
//   static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
//     final time = DateTime.now().millisecondsSinceEpoch.toString();
//     final Message message = Message(
//         toUserUid: chatUser.userUid,
//         message: msg,
//         read: '',
//         type: type,
//         fromUserUid: user.uid,
//         sent: time);
//     final ref = firestore.collection('allChats/${getConversationID(chatUser.userUid)}/userMessages/');
//     await ref.doc(time).set(message.toJson()).then((value) =>
//         sendPushNotification(chatUser, type == Type.text ? msg : 'image')
//     );
//   }
//
//   static Future<void> updateMessageReadStatus(Message message) async {
//     firestore
//         .collection('allChats/${getConversationID(message.fromUserUid)}/userMessages/')
//         .doc(message.sent)
//         .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
//   }
//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user) {
//     return firestore.collection('allChats/${getConversationID(user.userUid)}/userMessages/')
//         .orderBy('sent', descending: true)
//         .limit(1)
//         .snapshots();
//   }
//
//   static Future<void> sendChatImage(List<Message> _list, ChatUser chatUser, File file) async {
//     final ext = file.path.split('.').last;
//     final ref = storage.ref().child(
//         'allChatImages/${getConversationID(chatUser.userUid)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
//     await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'))
//         .then((p0) {
//       log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
//     });
//     final imageUrl = await ref.getDownloadURL();
//     _list.isNotEmpty ? await sendMessage(chatUser, imageUrl, Type.image) : await sendFirstMessage(chatUser, imageUrl, Type.image);
//   }
//
//   static Future<void> sendChatVoiceMessage(List<Message> _list, ChatUser chatUser, String audioPath) async {
//     String ext = path.extension(audioPath);
//     final ref = storage.ref().child(
//         'allChatVoiceMessage/${getConversationID(chatUser.userUid)}/${DateTime.now().millisecondsSinceEpoch}$ext');
//
//     await ref.putFile(File(audioPath), SettableMetadata(contentType: 'voice/$ext')).then((p0) {
//       log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
//     });
//
//     final voiceMessageUrl = await ref.getDownloadURL();
//     _list.isNotEmpty ? await sendMessage(chatUser, voiceMessageUrl, Type.voice) : await sendFirstMessage(chatUser, voiceMessageUrl, Type.audio);
//   }
//
//   static Future<void> deleteMessage(Message message) async {
//     await firestore.collection('allChats/${getConversationID(message.toUserUid)}/userMessages/')
//         .doc(message.sent)
//         .delete();
//     if(message.type == Type.voice){
//       await storage.refFromURL(message.message).delete();
//     }else if (message.type == Type.image) {
//       await storage.refFromURL(message.message).delete();
//     }
//   }
//
// }