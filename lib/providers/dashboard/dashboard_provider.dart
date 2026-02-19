import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiinver_project/api/endpoint/endpoint.dart';
import 'package:tiinver_project/screens/app_screens/camera/camera.dart';
import 'package:video_player/video_player.dart';
import '../../api/api_services/api_services.dart';
import '../../constant.dart';
import '../../models/feedTimeLineModel/feed_time_line_model.dart';

class DashboardProvider extends ChangeNotifier{

  bool isLoading = false;

  XFile? _image;

  XFile? get image => _image;

  late VideoPlayerController _controller;
  VideoPlayerController get controller => _controller;

  PageController? _pageController;
  int _currentPage = 0;

  void setCurrentPage(int index) {
    _pageController = PageController(initialPage: index);
    notifyListeners();
  }

  PageController? get pageController => _pageController;
  int get currentPage => _currentPage;

  DashboardProvider() {
    // _pageController.addListener(() {
    //   if (_pageController.hasClients) {
    //     int newPage = _pageController.page?.toInt() ?? 0;
    //     if (_currentPage != newPage) {
    //       _currentPage = newPage;
    //       notifyListeners();
    //     }
    //   }
    // });
  }

  void initialize(String url) {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: true,
      ),
    )..initialize().then((_) {
      _controller.play();
      notifyListeners();
    });

    _controller.addListener(() {
      notifyListeners();
    });
  }

  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = pickedFile;
      Get.to(()=>ImageViewer(filePath: _image!.path));
      notifyListeners();
    }
  }

  // List<Comment> _comments = [];
  // bool _loading = false;
  // String? _error;
  //
  // List<Comment> get comments => _comments;
  // bool get loading => _loading;
  // String? get error => _error;

  // bool isLoading = false;

  var commentC = TextEditingController();

  final StreamController<List<Comment>> _commentController = StreamController.broadcast();
  Stream<List<Comment>> get commentStream => _commentController.stream;

  final StreamController<List<Activity>> _timelineController = StreamController<List<Activity>>.broadcast();
  Stream<List<Activity>> get timelineStream => _timelineController.stream;

  List<Activity> _timeLine = [];

  List<Activity> get timeLine => _timeLine;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> fetchTimeline(int id, int limit, int offset, String userApiKey) async {
    try {
      final response = await ApiService.get(
        Endpoint.getFeedTimeLine(id, limit, offset),
        header2(userApiKey),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (!jsonResponse['error']) {
          final List<Activity> activities = (jsonResponse['activities'] as List)
              .map((activity) => Activity.fromJson(activity))
              .toList();
          _timelineController.add(activities);
          _timeLine = (jsonResponse['activities'] as List)
              .map((activity) => Activity.fromJson(activity))
              .toList();
          notifyListeners();
        } else {
          _timelineController.addError('Failed to load timeline');
        }
      } else {
        _timelineController.addError('Failed to load timeline');
      }
    } catch (e) {
      _timelineController.addError(e.toString());
    }
  }

  Future<void> fetchComments(int activityId, String userApiKey) async {
    try {
      final response = await ApiService.get(
          Endpoint.getComment(activityId),
          header2(userApiKey)
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (!jsonResponse['error']) {
          List<Comment> comments = (jsonResponse['comments'] as List)
              .map((comment) => Comment.fromJson(comment))
              .toList();
          _commentController.add(comments);
        } else {
          _commentController.addError('Failed to load comments');
        }
      } else {
        _commentController.addError('Failed to load comments');
      }
    } catch (e) {
      _commentController.addError(e.toString());
    }
  }

  // Future<void> fetchComments(int activityId, String userApiKey) async {
  //   _loading = true;
  //   notifyListeners();
  //
  //   try {
  //     final response = await ApiService.get(
  //         Endpoint.getComment(activityId),
  //         header2(userApiKey)
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = json.decode(response.body);
  //       if (!jsonResponse['error']) {
  //         _comments = (jsonResponse['comments'] as List)
  //             .map((comment) => Comment.fromJson(comment))
  //             .toList();
  //         _error = null;
  //       } else {
  //         _error = 'Failed to load comments';
  //       }
  //     } else {
  //       _error = 'Failed to load comments';
  //     }
  //   } catch (e) {
  //     _error = e.toString();
  //     _comments = [];
  //   } finally {
  //     _loading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> postComment({
    required String activityId,
    required String userId,
    required String userApiKey,
  }) async {
    log(activityId);
    log(userId);
    isLoading = true;
    notifyListeners();
    try {

      final body = {
        'activityId': activityId,
        'userId': userId,
        'comment': commentC.text.toString(),
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(userApiKey),
          endPoint: Endpoint.comment
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
      isLoading = false;
      commentC.text = "";
      notifyListeners();
    }
  }

  Future<void> likeOrUnlike({
    required String activityId,
    required String userId,
    required String userApiKey,
  }) async {
    log(activityId);
    log(userId);
    isLoading = true;
    notifyListeners();
    try {

      final body = {
        "activityId" : activityId,
        "userId" : userId,
        "verb" : "like",
        "status" : "LIKE",
        "object" : "photo",
      };
//or UNLIKE

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(userApiKey),
          endPoint: Endpoint.likeOrUnlike
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
      isLoading = false;
      commentC.text = "";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(notifyListeners);
    _controller.dispose();
    _timelineController.close();
    _pageController!.dispose();
    super.dispose();
  }
}