// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:provider/provider.dart';
//
// class SocketService {
//
//   late IO.Socket socket;
//
//   void initSocket(String userId) {
//     socket = IO.io(
//       'https://api.tiinver.com:2020',
//       IO.OptionBuilder()
//           .setTransports(['websocket']) // for Flutter or Dart VM
//           .setQuery({'userId': userId})
//           .build(),
//     );
//
//     socket.onConnect((_) {
//       print('connected');
//     });
//
//     socket.onDisconnect((_) {
//       print('disconnected');
//     });
//   }
//
//   void sendMessage(
//       String from,
//       String to,
//       String messageId,
//       int messageSize,
//       int creationDate,
//       int deliverTime,
//       Map<String, dynamic> packet,
//       ) async {
//     final response = await http.post(
//       Uri.parse('https://tiinver.com/api/v1/createmessage'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode({
//         'from': from,
//         'to': to,
//         'messageId': messageId,
//         'messageSize': messageSize,
//         'creationDate': creationDate,
//         'deliver_time': deliverTime,
//         'packet': packet,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       print('Message sent successfully');
//     } else {
//       throw Exception('Failed to send message');
//     }
//   }
//
//   void listenForMessages(Function onMessageReceived) {
//     socket.on('receive_message', (data) {
//       onMessageReceived(data);
//     });
//   }
//
//   void disconnect() {
//     socket.disconnect();
//   }
// }
//
// class ChatProvider with ChangeNotifier {
//   SocketService _socketService = SocketService();
//   List<Map<String, dynamic>> _messages = [];
//   List<Map<String, dynamic>> get messages => _messages;
//
//   ChatProvider(String userId, String chatId) {
//     _socketService.initSocket(userId);
//     _socketService.listenForMessages(_onMessageReceived);
//     fetchInitialMessages(chatId);
//   }
//
//   void _onMessageReceived(dynamic data) {
//     _messages.add(data);
//     notifyListeners();
//   }
//
//   Future<void> fetchInitialMessages(String chatId) async {
//     final response = await http.get(Uri.parse('https://tiinver.com/api/v1/message/$chatId'));
//     if (response.statusCode == 200) {
//       Map<String, dynamic> responseData = json.decode(response.body);
//       List<dynamic> data = responseData['data'];
//       _messages = data.map((e) => e as Map<String, dynamic>).toList();
//       notifyListeners();
//     } else {
//       throw Exception('Failed to load messages');
//     }
//   }
//
//   void sendMessage(
//       String from,
//       String to,
//       String messageId,
//       int messageSize,
//       int creationDate,
//       int deliverTime,
//       Map<String, dynamic> packet,
//       ) {
//     _messages.add(packet);
//     _socketService.sendMessage(from, to, messageId, messageSize, creationDate, deliverTime, packet);
//     notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     _socketService.disconnect();
//     super.dispose();
//   }
// }
//
// class ChatScreen extends StatelessWidget {
//   final String userId;
//   final String chatId;
//
//   ChatScreen({required this.userId, required this.chatId});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ChatProvider(userId, chatId),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Chat'),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: Consumer<ChatProvider>(
//                 builder: (context, chatProvider, child) {
//                   return ListView.builder(
//                     itemCount: chatProvider.messages.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(chatProvider.messages[index]['message']),
//                         subtitle: Text(chatProvider.messages[index]['from']),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             _MessageInput(chatId: chatId),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _MessageInput extends StatelessWidget {
//   final String chatId;
//   final TextEditingController _controller = TextEditingController();
//
//   _MessageInput({required this.chatId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 hintText: 'Enter your message',
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: () {
//               if (_controller.text.isNotEmpty) {
//                 final messageId = DateTime.now().millisecondsSinceEpoch.toString();
//                 final messagePacket = {
//                   "messageId": messageId,
//                   "conversationId": chatId,
//                   "type": "chat",
//                   "to": "SO_199",
//                   "sender": "2146",
//                   "receiver": "196",
//                   "from": "BaibéDje",
//                   "nikname": "Baibé Dje Tissala  ",
//                   "message": _controller.text,
//                   "verb": "post",
//                   "object": "text",
//                   "profile": "https://tiinver.com/api/uploads/profiles/default.png",
//                   "status": "0",
//                   "stamp": DateTime.now().millisecondsSinceEpoch.toString(),
//                   "resource": "Infinix X669",
//                   "isQuoted": "false"
//                 };
//
//                 Provider.of<ChatProvider>(context, listen: false).sendMessage(
//                   "BaibéDje",
//                   "SO_199",
//                   messageId,
//                   1245,
//                   DateTime.now().millisecondsSinceEpoch,
//                   DateTime.now().millisecondsSinceEpoch,
//                   messagePacket,
//                 );
//                 _controller.clear();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }


