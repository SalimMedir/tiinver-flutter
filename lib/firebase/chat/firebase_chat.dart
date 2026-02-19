// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart' as path;
//
// import '../../gloabal_key.dart';
// import '../../models/chatModel/chat_model.dart';
// import '../../models/msgModel/msg_model.dart';
// import '../../providers/signIn/sign_in_provider.dart';
//
//
// class FirebaseChat {
//
//   final SignInProvider signInProvider;
//
//   FirebaseChat(this.signInProvider);
//
//   // final signProvider = GlobalProviderAccess.signProvider;
//
//   //static FirebaseAuth get auth => FirebaseAuth.instance;
//   static FirebaseFirestore fireStore = FirebaseFirestore.instance;
//   static FirebaseStorage storage = FirebaseStorage.instance;
//   static SignInProvider? get user => GlobalProviderAccess.signProvider;
//
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
//     return fireStore
//         .collection('users')
//         .doc(user!.userId)
//         .collection('myContacts')
//         .snapshots();
//   }
//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(List<String> userIds) {
//     return fireStore
//         .collection('users')
//         .where('id',
//         whereIn: userIds.isEmpty
//             ? ['']
//             : userIds)
//         .snapshots();
//   }
//
//   static Future<void> sendFirstMessage(ChatUser chatUser, String msg, Type type) async {
//     await fireStore
//         .collection('users')
//         .doc(chatUser.id)
//         .collection('myContacts')
//         .doc(user!.userId)
//         .set({}).then((value) => sendMessage(chatUser, msg, type));
//   }
//
//   static String getConversationID(String id) {
//     return user!.userId.hashCode <= id.hashCode ? '${user!.userId}_$id' : '${id}_${user!.userId}';
//   }
//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
//     return fireStore
//         .collection('allChats/${getConversationID(user.id)}/userMessages/')
//         .orderBy('sent', descending: true)
//         .snapshots();
//   }
//
//   static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
//     final time = DateTime.now().millisecondsSinceEpoch.toString();
//     final Message message = Message(
//         toUserUid: chatUser.id,
//         message: msg,
//         read: '',
//         type: type,
//         fromUserUid: user!.userId.toString(),
//         sent: time);
//     final ref = fireStore.collection('allChats/${getConversationID(chatUser.id)}/userMessages/');
//     await ref.doc(time).set(message.toJson()).then((value) =>
//         sendPushNotification(chatUser, type == Type.text ? msg : 'image')
//     );
//   }
//
//   static Future<void> updateMessageReadStatus(Message message) async {
//     fireStore
//         .collection('allChats/${getConversationID(message.fromUserUid)}/userMessages/')
//         .doc(message.sent)
//         .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
//   }
//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user) {
//     return fireStore.collection('allChats/${getConversationID(user.id)}/userMessages/')
//         .orderBy('sent', descending: true)
//         .limit(1)
//         .snapshots();
//   }
//
//   static Future<void> sendChatImage(List<Message> _list, ChatUser chatUser, File file) async {
//     final ext = file.path.split('.').last;
//     final ref = storage.ref().child(
//         'allChatImages/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
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
//         'allChatVoiceMessage/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}$ext');
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
//     await fireStore.collection('allChats/${getConversationID(message.toUserUid)}/userMessages/')
//         .doc(message.sent)
//         .delete();
//     if(message.type == Type.voice){
//       await storage.refFromURL(message.message).delete();
//     }else if (message.type == Type.image) {
//       await storage.refFromURL(message.message).delete();
//     }
//   }
//
//   static Future<void> createGroup(String groupName, List<String> memberUids) async {
//     final groupId = fireStore.collection('allGroups').doc().id;
//     final group = {
//       'documentId': groupId,
//       'groupName': groupName,
//       'groupMembersUid': memberUids,
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//
//     // Add group info to Firestore
//     await fireStore.collection('groups').doc(groupId).set(group);
//
//     // Add group to each member's 'myContacts' collection
//     for (var uid in memberUids) {
//       await fireStore
//           .collection('users')
//           .doc(uid)
//           .collection('myContacts')
//           .doc(groupId)
//           .set({'groupId': groupId, 'groupName': groupName, 'isGroup': true});
//     }
//   }
//
//   static Future<void> addGroupMember(String groupId, String userUid) async {
//     final groupRef = fireStore.collection('allGroups').doc(groupId);
//     await groupRef.update({
//       'memberUids': FieldValue.arrayUnion([userUid])
//     });
//
//     // Add group to the user's 'myContacts' collection
//     final groupDoc = await groupRef.get();
//     if (groupDoc.exists) {
//       final groupName = groupDoc['name'];
//       await fireStore
//           .collection('users')
//           .doc(userUid)
//           .collection('myContacts')
//           .doc(groupId)
//           .set({'groupId': groupId, 'groupName': groupName, 'isGroup': true});
//     }
//   }
//
//   static Future<void> removeGroupMember(String groupId, String userUid) async {
//     final groupRef = fireStore.collection('allGroups').doc(groupId);
//     await groupRef.update({
//       'memberUids': FieldValue.arrayRemove([userUid])
//     });
//
//     // Remove group from the user's 'myContacts' collection
//     await fireStore
//         .collection('users')
//         .doc(userUid)
//         .collection('myContacts')
//         .doc(groupId)
//         .delete();
//   }
// }