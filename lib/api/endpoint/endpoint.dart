import 'package:tiinver_project/api/base/base_urls.dart';

import '../../models/login/user_login_model.dart';

UserLoginModel? _user;

const header1 = {
  'Content-Type': 'application/x-www-form-urlencoded',
};

Map<String, String> header2(userApiKey) {
  return {
    'Content-Type': 'application/x-www-form-urlencoded',
    'x-tiinver-token': userApiKey?.toString() ?? '',
  };
}

class Endpoint{
  static final forgotPassword = BaseUrls.throughProxy('/forgotpassword');
  static final geolocation = BaseUrls.throughProxy('/geolocation');
  static final transfer = BaseUrls.throughProxy('/transfert');
  static final register = BaseUrls.throughProxy('/register');
  static final logout = BaseUrls.throughProxy('/logout');
  static final deleteAccount = BaseUrls.throughProxy('/deleteaccount');
  static final createGroup = BaseUrls.throughProxy('/group');
  static final deleteGroup = BaseUrls.throughProxy('/deletegroup');
  static final updateGroup = BaseUrls.throughProxy('/updategroup');
  static final membership = BaseUrls.throughProxy('/membership');
  static final groupMessage = BaseUrls.throughProxy('/group/message');
  static final leftGroup = BaseUrls.throughProxy('/leftgroup');
  static final updateMember = BaseUrls.throughProxy('/member/update');
  static final deleteMember = BaseUrls.throughProxy('/deleteMember');
  static final login = BaseUrls.throughProxy('/login');
  static final sendOtp = BaseUrls.throughProxy('/sendotp');
  static final comment = BaseUrls.throughProxy('/comment');
  static final isPhoneOrEmailExists = BaseUrls.throughProxy('/isPhoneOrEmailExiste');
  static final blockUser = BaseUrls.throughProxy('/block');
  static final privateMessage = BaseUrls.throughProxy('/createmessage');
  static final likeOrUnlike = BaseUrls.throughProxy('/reaction');
  static final follow = BaseUrls.throughProxy('/follow');
  static final unfollow = BaseUrls.throughProxy('/unfollow');
  static final addActivity = BaseUrls.throughProxy('/activity/add');
  static final updateUser = BaseUrls.throughProxy('/user');
  static final updateProfile = BaseUrls.throughProxy('/updateprofile');
  static final report = BaseUrls.throughProxy('/report');

  static String followers(int userId, int followerId) {
    return BaseUrls.throughProxy('/followers/$userId/$followerId/20/0');
  }

  static String following(int userId, int followerId) {
    return BaseUrls.throughProxy('/following/$userId/$followerId/20/0');
  }

  static String getUser(int userId,int followerId) {
    return BaseUrls.throughProxy('/getuserbyid/$userId/$followerId');
  }

  static String getFeedTimeLine(int id, int limit, int offset) {
    return BaseUrls.throughProxy('/feedtimeline/$id/$limit/$offset');
  }

  static String getMedia(int actorId,int myId, int limit, int offset) {
    return BaseUrls.throughProxy('/feedtimeline/$actorId/$myId/$limit/$offset');
  }

  static String getConnectedUser(int userId) {
    return BaseUrls.throughProxy('/connectedusers/$userId');
  }

  static String getComment(int activityId) {
    return BaseUrls.throughProxy('/comment/$activityId/50/0');
  }

  static String getSuggestion(int userId) {
    return BaseUrls.throughProxy('/suggestions/$userId');
  }

  static String getNotification(int userId) {
    return BaseUrls.throughProxy('/notification/$userId');
  }

  static String getMessage(int userId) {
    return BaseUrls.throughProxy('/message/$userId');
  }

  static String search(String userId, String query) {
    return BaseUrls.throughProxy('/Allsearchs/$userId/$query');
  }

}
