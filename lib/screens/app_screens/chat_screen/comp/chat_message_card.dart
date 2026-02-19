import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';

import '../../../../firebase/chat/firebase_chat.dart';
import '../../../../models/msgModel/msg_model.dart';
import '../../chat_home_screen/comp/date_util.dart';

// class MessageCard extends StatefulWidget {
//   const MessageCard({super.key, required this.message});
//
//   final Message message;
//
//   @override
//   State<MessageCard> createState() => _MessageCardState();
// }

// class _MessageCardState extends State<MessageCard> {
//   late AudioPlayer _audioPlayer;
//   bool _isPlaying = false;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isMe = FirebaseChat.user!.userId == widget.message.fromUserUid;
//     return InkWell(
//         onTap: () {
//           if(widget.message.type == Type.image) _showChatImage();
//         },
//         onLongPress: () => _showBottomSheet(isMe),
//         child: isMe ? _myMessage(isMe) : _receiveMessage(isMe));
//   }
//
//   Widget _receiveMessage(bool isMe) {
//     if (widget.message.read.isEmpty) {
//       FirebaseChat.updateMessageReadStatus(widget.message);
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Flexible(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 constraints: BoxConstraints(
//                   maxWidth: 80.w,
//                 ),
//                 margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.0.w),
//                 decoration: const BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 0.5,
//                         spreadRadius: 0.5,
//                         offset: Offset(0.1, 0.4)
//                     )
//                   ],
//                   color: lightGreyColor,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10.0),
//                       topRight: Radius.circular(10.0),
//                       bottomRight: Radius.circular(10.0)
//                   ),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical:  widget.message.type == Type.image ? 1.0.h : 0.5.h),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     widget.message.type != Type.image ? widget.message.type == Type.voice
//                         ? _buildAudioWaveform(isMe)
//                         : Container(
//                       constraints: BoxConstraints(
//                         maxWidth: 80.w
//                       ),
//                           child: Text(
//                             widget.message.message,
//                             maxLines: null,
//                             overflow: TextOverflow.visible,
//                             style: TextStyle(
//                           color: textColor,
//                           fontSize: 13.0.sp,
//                           fontWeight: FontWeight.w400,
//                                                 ),
//                                               ),
//                         )
//                         : showChatImageMessage(widget.message.message),
//                     SizedBox(height: 0.5.h),
//                     Text(
//                       MyDateUtil.getFormattedTime(
//                           context: context, time: widget.message.sent),
//                       style: TextStyle(
//                         fontSize: 10.0.sp,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _myMessage(bool isMe) {
//     return Row(
//       children: [
//         const Spacer(),
//         Container(
//           margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.0.w),
//           decoration: const BoxDecoration(
//             color: themeColor,
//             borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(10.0),
//                 topRight: Radius.circular(10.0),
//                 topLeft: Radius.circular(10.0)
//             ),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical:  widget.message.type == Type.image ? 1.0.h : 0.5.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               widget.message.type != Type.image
//                   ? widget.message.type == Type.voice ?
//               // AudioWaveForm(message: widget.message.message)
//               _buildAudioWaveform(isMe)
//                   : Container(
//                 constraints: BoxConstraints(
//                   maxWidth: 80.w
//                 ),
//                 child: Text(
//                   widget.message.message,
//                   maxLines: null,
//                   overflow: TextOverflow.visible,
//                   style: TextStyle(
//                     color: bgColor,
//                     fontSize: 13.0.sp,
//                     fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                   )
//                   : showChatImageMessage(widget.message.message),
//               SizedBox(height: 0.5.h),
//               Row(
//                 children: [
//                   Text(
//                     MyDateUtil.getFormattedTime(
//                         context: context, time: widget.message.sent),
//                     style: TextStyle(
//                       fontSize: 10.0.sp,
//                       color: Colors.white.withOpacity(0.6),
//                     ),
//                   ),
//                   SizedBox(width: 1.0.w),
//                   widget.message.read.isNotEmpty ? const Icon(Icons.done_all, color: Colors.greenAccent, size: 17.0,) : const Icon(Icons.check, color: Colors.white, size: 17.0,)
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAudioWaveform(bool isMe) {
//     var url = UrlSource(widget.message.message.toString());
//     return Column(
//       children: [
//         Container(
//           constraints: BoxConstraints(
//             maxWidth: 40.w
//           ),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                 color: isMe ?  bgColor : textColor,
//                 onPressed: () async{
//                   if (_isPlaying) {
//                     await _audioPlayer.pause();
//                     setState(() {
//                       _isPlaying = false;
//                     });
//                   } else {
//                     await _audioPlayer.play(url);
//                     setState(() {
//                       _isPlaying = true;
//                     });
//                     _audioPlayer.onPlayerComplete.listen((event) {
//                       setState(() {
//                         _isPlaying = false;
//                       });
//                     });
//                   }
//                 },
//               ),
//               Text(
//                 _isPlaying ? "Playing" : "Paused",
//                 style: TextStyle(color: isMe ?  bgColor : textColor),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget showChatImageMessage(var message) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//       child: CachedNetworkImage(
//         height: 23.0.h,
//         width: 23.0.h,
//         imageUrl: message,
//         fit: BoxFit.cover,
//         placeholder: (context, url) => const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: CircularProgressIndicator(strokeWidth: 2),
//         ),
//         errorWidget: (context, url, error) =>
//         const Icon(Icons.image, size: 70),
//       ),
//     );
//   }
//
//   // void _showBottomSheet(bool isMe) {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     isDismissible: true,
//   //     backgroundColor: bgColor,
//   //     shape: const RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.only(
//   //         topLeft: Radius.circular(20),
//   //         topRight: Radius.circular(20),
//   //       ),
//   //     ),
//   //     builder: (_) {
//   //       return DraggableScrollableSheet(
//   //         initialChildSize: 0.56,
//   //         maxChildSize: 0.56,
//   //         expand: false,
//   //         builder: (BuildContext context, ScrollController scrollController) {
//   //           return Column(
//   //             children: [
//   //               Container(
//   //                 height: 4.0,
//   //                 width: 40.0,
//   //                 margin: EdgeInsets.symmetric(vertical: 1.7.h),
//   //                 decoration: BoxDecoration(
//   //                   color: Colors.grey,
//   //                   borderRadius: BorderRadius.circular(8),
//   //                 ),
//   //               ),
//   //               widget.message.type == Type.text
//   //                   ? _OptionItem(
//   //                   icon: const Icon(Icons.copy_all_rounded,
//   //                       color: Colors.blue, size: 26),
//   //                   name: 'Copy Text',
//   //                   onTap: () async {
//   //                     await Clipboard.setData(
//   //                         ClipboardData(text: widget.message.message))
//   //                         .then((value) {
//   //                       Navigator.pop(context);
//   //                       // Dialogs.showSnackbar(context, 'Text Copied!');
//   //                     });
//   //                   })
//   //                   : _OptionItem(
//   //                   icon: const Icon(Icons.download_rounded,
//   //                       color: Colors.blue, size: 26),
//   //                   name: 'Save Image',
//   //                   onTap: () async {
//   //                     // try {
//   //                     //   await GallerySaver.saveImage(
//   //                     //       widget.message.message,
//   //                     //       albumName: 'Hello Chat')
//   //                     //       .then((success) {
//   //                     //     Navigator.pop(context);
//   //                     //     if (success != null && success) {
//   //                     //       Get.snackbar('Chat App', 'Image Successfully Saved!');
//   //                     //     }
//   //                     //   });
//   //                     // } catch (e) {
//   //                     //   log('ErrorWhileSavingImg: $e');
//   //                     // }
//   //                   }),
//   //               if (isMe)
//   //                 _OptionItem(
//   //                     icon: const Icon(Icons.delete_forever,
//   //                         color: Colors.red, size: 26),
//   //                     name: 'Delete Message',
//   //                     onTap: () async {
//   //                       await FirebaseChat.deleteMessage(widget.message).then((value) {
//   //                         Navigator.pop(context);
//   //                       });
//   //                     }),
//   //               Divider(
//   //                 color: Colors.grey,
//   //                 endIndent: 5.0.w,
//   //                 indent: 5.0.w,
//   //               ),
//   //               _OptionItem(
//   //                   icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
//   //                   name:
//   //                   'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
//   //                   onTap: () {}),
//   //               _OptionItem(
//   //                   icon: const Icon(Icons.remove_red_eye, color: Colors.green),
//   //                   name: widget.message.read.isEmpty
//   //                       ? 'Read At: Not seen yet'
//   //                       : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
//   //                   onTap: () {}),
//   //             ],
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//
//   void _showChatImage() {
//     showDialog(
//       useSafeArea: true,
//       barrierDismissible: true,
//       context: context, builder: (context) {
//       return Dialog(
//         backgroundColor: Colors.transparent,
//         surfaceTintColor: Colors.transparent,
//         child: CachedNetworkImage(
//             imageUrl: widget.message.message
//         ),
//       );
//     },);
//   }
// }

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: 5.0.w,
              top: 1.5.h,
              bottom: 1.5.h),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}