import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/models/getUserModel/get_user_model.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';
import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../constant.dart';
import '../../gloabal_key.dart';
import '../../models/feedTimeLineModel/feed_time_line_model.dart';
import '../../models/followersModel/followers_model.dart';
import '../../models/followingModel/following_model.dart';
import '../../models/register/user_sign_up_model.dart';

class ProfileProvider with ChangeNotifier {

  final signProvider = GlobalProviderAccess.signProvider;

  var nameController = TextEditingController();
  var locationController = TextEditingController();
  var workController = TextEditingController();
  var qualificationController = TextEditingController();
  var schoolController = TextEditingController();

  bool _isLoading = false;

  bool get  isLoading => _isLoading;

  UserSignUpModel? _user;

  UserSignUpModel? get user => _user;

  final StreamController<List<Users>> _followersController = StreamController<List<Users>>.broadcast();
  Stream<List<Users>> get followersStream => _followersController.stream;

  final StreamController<List<FollowingUsers>> _followingController = StreamController<List<FollowingUsers>>.broadcast();
  Stream<List<FollowingUsers>> get followingStream => _followingController.stream;

  final Map<int, bool> _loadingStates = {};
  bool isLoadingForUser(int userId) => _loadingStates[userId] ?? false;

  GetUserModel _userModel = GetUserModel();

  GetUserModel get userModel => _userModel;

  Users followerUser = Users();

  final StreamController<List<Activity>> _mediaController = StreamController<List<Activity>>.broadcast();
  Stream<List<Activity>> get mediaStream => _mediaController.stream;

  List<Activity> _media = [];

  List<Activity> get media => _media;

  // Future<void> loadUserProfileFromPreferences() async {
  //   var sp = await SharedPreferences.getInstance();
  //   String? userJson = sp.getString('userProfileData');
  //   if (userJson != null) {
  //     userModel = GetUserModel.fromJson(json.decode(userJson));
  //   }
  //   notifyListeners();
  // }

  // Future<void> loadUserFromPreferences() async {
  //   var sp = await SharedPreferences.getInstance();
  //   String? userJson = sp.getString('getUserModel');
  //   if (userJson != null) {
  //     _userModel = GetUserModel.fromJson(json.decode(userJson));
  //   }
  //   notifyListeners();
  // }

  clearList(){
    _followingController.close();
    _followersController.close();
    notifyListeners();
  }

  getUserProfile(context) async {
    try{

      // isLoading = true;

      var res = await ApiService.get(
          Endpoint.getUser(
              int.parse(Provider.of<SignInProvider>(context,listen: false).userId!),
              int.parse(Provider.of<SignInProvider>(context,listen: false).userId!)
          ),
          header2(Provider.of<SignInProvider>(context,listen: false).userApiKey));

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map<String, dynamic> jsonResponse = json.decode(res.body);
        if (jsonResponse['error'] == false) {

          _userModel = GetUserModel.fromJson(jsonResponse['userData']);

          // Assign values to variables
          nameController.text = _userModel.firstname!;
          qualificationController.text = _userModel.qualification!;
          workController.text = _userModel.work!;
          schoolController.text = _userModel.school!;
          locationController.text = _userModel.location!;
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

  Future<void> fetchMedia(int actorId, int id, int limit, int offset, String userApiKey) async {
    try {
      final response = await ApiService.get(
        Endpoint.getMedia(actorId ,id, limit, offset),
        header2(userApiKey),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (!jsonResponse['error']) {
          final List<Activity> activities = (jsonResponse['activities'] as List)
              .map((activity) => Activity.fromJson(activity))
              .toList();
          _mediaController.add(activities);
          _media = (jsonResponse['activities'] as List)
              .map((activity) => Activity.fromJson(activity))
              .toList();
          notifyListeners();
        } else {
          _mediaController.addError('Failed to load timeline');
        }
      } else {
        _mediaController.addError('Failed to load timeline');
      }
    } catch (e) {
      _mediaController.addError(e.toString());
    }
  }

  Future<void> updateProfile({
    required String id,
    required String name,
    required String qualification,
    required String workAt,
    required String school,
    required String location,
    required String userApiKey,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {

      final body = {
        'id': id,
        'firstname': name,
        'lastname': 'g',
        'workAt': workAt,
        'location': location,
        'qualification': qualification,
        'school': school,
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(userApiKey),
          endPoint: Endpoint.updateProfile
      );

      log("message: ${res.body}");
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['message'];
        log("message: ${res.body}");

        if(error){
          Get.snackbar("error", message);
        }else{
          Get.snackbar("success", message);
        }
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> followers(int userId, BuildContext context) async {
    try {
      final response = await ApiService.get(
        Endpoint.followers(userId, userId),
        header2(Provider.of<SignInProvider>(context, listen: false).userApiKey),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (!jsonResponse['error']) {
          final List<dynamic> data = jsonResponse['users'];
          final List<Users> followersList = data.map((item) => Users.fromJson(item)).toList();
          _followersController.add(followersList); // Add the list to the stream
        } else {
          throw Exception('Failed to load users');
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      _followersController.addError(e);
    }
  }

  Future<void> following(int userId, BuildContext context) async {
    try {
      _setLoadingState(userId, true);

      final response = await ApiService.get(
        Endpoint.following(userId, userId),
        header2(Provider.of<SignInProvider>(context, listen: false).userApiKey),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (!jsonResponse['error']) {
          final List<dynamic> data = jsonResponse['users'];
          final List<FollowingUsers> followingsList = data.map((item) => FollowingUsers.fromJson(item)).toList();
          _followingController.add(followingsList);
        } else {
          throw Exception('Failed to load users');
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      _followingController.addError(e);
    } finally {
      _setLoadingState(userId, false);
    }
  }

  Future<void> follow({
    required String followId,
    required String userId,
    required String userApiKey,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _setLoadingState(int.parse(userId), true);

      final body = {
        'followId': followId,
        'userId': userId,
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(userApiKey),
          endPoint: Endpoint.follow
      );

      log("message: ${res.body}");
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final message = jsonResponse['message'];
        log("message: ${res.body}");

        if(error){
          Get.snackbar("error", message);
        }else{
          Get.snackbar("success", message);
        }
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }finally{
      _setLoadingState(int.parse(userId), false);
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setLoadingState(int userId, bool isLoading) {
    _loadingStates[userId] = isLoading;
    notifyListeners();
  }

  Future<void> deleteAccount({
    required String userId,
    required String userApiKey,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {

      final body = {
        'userId': userId,
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(signProvider!.userApiKey),
          endPoint: Endpoint.deleteAccount
      );

      log("message: ${res.body}");
      if(res.statusCode == 200 || res.statusCode == 201){

        final jsonResponse = jsonDecode(res.body);
        final error = jsonResponse['error'];
        final msg = jsonResponse['user'];
        log("message: ${res.body}");

        if(error){
          Get.snackbar("Error", "Something went wrong!");
        }else{
          Get.snackbar("Successful", msg);
          signProvider!.logout();
        }
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mediaController.close();
    super.dispose();
  }

}
