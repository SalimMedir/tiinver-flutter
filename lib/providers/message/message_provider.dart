import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/models/msgModel/get_message_model.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import '../../DatabaseHelper/database_helper.dart';
import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../constant.dart';
import '../../gloabal_key.dart';

class MessageProvider extends ChangeNotifier{

  SignInProvider signInProvider = SignInProvider();
  final DatabaseHelper _dbHelper = DatabaseHelper();


  bool isLoading = false;
  Data _getMessage = Data();

  getMessage(context) async {
    try{

      // isLoading = true;
//int.parse(Provider.of<SignInProvider>(context,listen: false).userId!)
      var res = await ApiService.get(
          Endpoint.getMessage(
              197,
          ),
          header2(Provider.of<SignInProvider>(context,listen: false).userApiKey));

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> jsonResponse = json.decode(res.body);
        if (jsonResponse['error'] == false) {

          _getMessage = Data.fromJson(jsonResponse['data']);

          _dbHelper.saveMessage(
            _getMessage.conversationId.toString(),
            _getMessage.sender.toString(),
            _getMessage.message.toString(),
            "/data/user/0/com.tiinver.tiinver_project/app_flutter/voice_message_1723290588030.mp3",
            _getMessage.receiver.toString(),
            "IssaMahamat",
          );

          // Assign values to variables
          // nameController.text = _userModel.firstname!;
          // qualificationController.text = _userModel.qualification!;
          // workController.text = _userModel.work!;
          // schoolController.text = _userModel.school!;
          // locationController.text = _userModel.location!;
          notifyListeners();

          //log("*******${name}******");

        } else {
          throw Exception('Failed to load users');
        }
        //log(followingsList.toString());
      }
    }catch(e){
      print(e);
    }
    // finally{
    // }
  }


  Future<void> sendPrivateMsg({
    required String msg,
    required String from,
    required String to,
    required String msgSize,
    required String chatRoomId,
    required String msgId,
    required String receiverId,
  }) async {
    isLoading = true;
    notifyListeners();
    try {

      // int msgId = random.nextInt(1000000000);
      var date = DateTime.timestamp();

      final packet = {
        "messageId": msgId.toString(),
        "conversationId": chatRoomId,
        "type": "chat",
        "to": to,
        "sender": from,
        "receiver": receiverId,
        "from": from,
        "nikname": to,
        "message": msg,
        "verb": "post",
        "object": "text",
        "profile": "https://tiinver.com/api/uploads/profiles/default.png",
        "status": "0",
        "stamp": date.toString(),
        "resource": "Infinix X669",
        "isQuoted": "false"
      };

      final body = {
        'from': from,
        'to': to,
        'messageId': msgId.toString(),
        'messageSize': msgSize,
        'creationDate': date.toString(),
        'deliver_time': date.toString(),
        'packet': jsonEncode(packet),
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(GlobalProviderAccess.signProvider!.userApiKey.toString()),
          endPoint: Endpoint.privateMessage
      );

      debugPrint("message: ${res.body}");
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['message'];
        debugPrint("message: ${res.body}");

        if(error){
          log("************$message***********");
          // Get.snackbar("error", message);
        }else{
          log("************$message***********");
          // Get.snackbar("success", message);
        }
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }

}
