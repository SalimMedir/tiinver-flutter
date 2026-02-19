// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart' as path;
//
//
// class FirebaseGroupChat {
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
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getUserGroups() {
//     return firestore
//         .collection('userAccount')
//         .doc(user.uid)
//         .collection('myGroups')
//         .snapshots();
//   }
//
//   static Stream<QuerySnapshot<Map<String, dynamic>>> getGroupMessages(String groupId) {
//     return firestore
//         .collection('groups')
//         .doc(groupId)
//         .collection('messages')
//         .orderBy('sent', descending: true)
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
//   static Future<void> createGroup(String groupName, List<String> memberUids) async {
//     final groupId = firestore.collection('allGroups').doc().id;
//     final group = {
//       'documentId': groupId,
//       'groupName': groupName,
//       'groupMembersUid': memberUids,
//       'createdAt': FieldValue.serverTimestamp(),
//     };
//
//     // Add group info to Firestore
//     await firestore.collection('groups').doc(groupId).set(group);
//
//     // Add group to each member's 'myContacts' collection
//     for (var uid in memberUids) {
//       await firestore
//           .collection('userAccount')
//           .doc(uid)
//           .collection('myContacts')
//           .doc(groupId)
//           .set({'groupId': groupId, 'groupName': groupName, 'isGroup': true});
//     }
//   }
//
//   static Future<void> addGroupMember(String groupId, String userUid) async {
//     final groupRef = firestore.collection('allGroups').doc(groupId);
//     await groupRef.update({
//       'memberUids': FieldValue.arrayUnion([userUid])
//     });
//
//     // Add group to the user's 'myContacts' collection
//     final groupDoc = await groupRef.get();
//     if (groupDoc.exists) {
//       final groupName = groupDoc['name'];
//       await firestore
//           .collection('userAccount')
//           .doc(userUid)
//           .collection('myContacts')
//           .doc(groupId)
//           .set({'groupId': groupId, 'groupName': groupName, 'isGroup': true});
//     }
//   }
//
//   static Future<void> removeGroupMember(String groupId, String userUid) async {
//     final groupRef = firestore.collection('allGroups').doc(groupId);
//     await groupRef.update({
//       'memberUids': FieldValue.arrayRemove([userUid])
//     });
//
//     // Remove group from the user's 'myContacts' collection
//     await firestore
//         .collection('userAccount')
//         .doc(userUid)
//         .collection('myContacts')
//         .doc(groupId)
//         .delete();
//   }
//
//   static Future<void> sendGroupMessage(String groupId, String messageContent, Type type) async {
//     final time = DateTime.now().millisecondsSinceEpoch.toString();
//     final message = Message(
//       toUserUid: groupId,
//       message: messageContent,
//       read: '',
//       type: type,
//       fromUserUid: user.uid,
//       sent: time,
//     );
//
//     final ref = firestore.collection('groups').doc(groupId).collection('messages');
//     await ref.doc(time).set(message.toJson()).then((value) => log('Message sent to group $groupId'));
//   }
// }