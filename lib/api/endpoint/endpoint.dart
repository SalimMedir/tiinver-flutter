import 'package:tiinver_project/api/base/base_urls.dart';

import '../../models/login/user_login_model.dart';

UserLoginModel? _user;

const header1 = {
  'Content-Type': 'application/x-www-form-urlencoded',
};

Map<String,String> header2(userApiKey){
  Map<String, String> header;
  return  header = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization' : userApiKey
  };
}

class Endpoint{
  static const forgotPassword = "${BaseUrls.BASEURL}forgotpassword";
  static const geolocation = "${BaseUrls.BASEURL}geolocation";
  static const transfer = "${BaseUrls.BASEURL}transfert";
  static const register = "${BaseUrls.BASEURL}register";
  static const logout = "${BaseUrls.BASEURL}logout";
  static const deleteAccount = "${BaseUrls.BASEURL}deleteaccount";
  static const createGroup = "${BaseUrls.BASEURL}group";
  static const deleteGroup = "${BaseUrls.BASEURL}deletegroup";
  static const updateGroup = "${BaseUrls.BASEURL}updategroup";
  static const membership = "${BaseUrls.BASEURL}membership";
  static const groupMessage = "${BaseUrls.BASEURL}group/message";
  static const leftGroup = "${BaseUrls.BASEURL}leftgroup";
  static const updateMember = "${BaseUrls.BASEURL}member/update";
  static const deleteMember = "${BaseUrls.BASEURL}deleteMember";
  static const login = "${BaseUrls.BASEURL}login";
  static const search = "${BaseUrls.BASEURL}usersbykey";
  static const mail = "${BaseUrls.BASEURL}mail";
  static const comment = "${BaseUrls.BASEURL}comment";
  static const isPhoneOrEmailExists = "${BaseUrls.BASEURL}isPhoneOrEmailExiste";
  static const blockUser = "${BaseUrls.BASEURL}block";
  static const privateMessage = "${BaseUrls.BASEURL}createmessage";
  static const likeOrUnlike = "${BaseUrls.BASEURL}reaction";

  static String followers(int userId, int followerId) {
    return 'https://tiinver.com/api/v1/followers/$userId/$followerId';
  }

  static String following(int userId, int followerId) {
    return 'https://tiinver.com/api/v1/following/$userId/$followerId';
  }

  static String getUser(int userId,int followerId) {
    return 'https://tiinver.com/api/v1/getuserbyid/$userId/$followerId';
  }

  static String getFeedTimeLine(int id, int limit, int offset) {
    return 'https://tiinver.com/api/v1/feedtimeline/$id/$limit/$offset';
  }

  static String getMedia(int actorId,int myId, int limit, int offset) {
    return 'https://tiinver.com/api/v1/feedtimeline/$actorId/$myId/$limit/$offset';
  }

  static String getConnectedUser(int userId) {
    return 'https://tiinver.com/api/v1/connectedusers/$userId';
  }

  static String getComment(int activityId) {
    return 'https://tiinver.com/api/v1/allcomment/$activityId';
  }

  static String getSuggestion(int userId) {
    return 'https://tiinver.com/api/v1/suggestions/$userId';
  }

  static String getNotification(int userId) {
    return 'https://tiinver.com/api/v1/notification/$userId';
  }

  static String getMessage(int userId) {
    return 'https://tiinver.com/api/v1/message/$userId';
  }

  static const report = "${BaseUrls.BASEURL}report";
  static const updateUser = "${BaseUrls.BASEURL}user";
  static const updateProfile = "${BaseUrls.BASEURL}updateProfile";
  static const updatePassword = "${BaseUrls.BASEURL}updatepassword";
  static const unfollow = "${BaseUrls.BASEURL}unfollow";
  static const follow = "${BaseUrls.BASEURL}follow";
  static const addActivity = "${BaseUrls.BASEURL}addactivity";

}