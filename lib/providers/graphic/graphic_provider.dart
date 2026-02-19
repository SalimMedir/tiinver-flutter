import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';

import '../../api/api_services/api_services.dart';
import '../../api/endpoint/endpoint.dart';
import '../../constant.dart';

class GraphicProvider with ChangeNotifier {

  // SignInProvider signInProvider = SignInProvider();

  TextEditingController _textController = TextEditingController();
  Color _backgroundColor = darkGreyColor;
  Color _textColor = Colors.black;
  Color _pointerColor = Colors.black;
  XFile? _image;
  bool _isBackground = false;
  bool _isDrawing = false;
  bool _isLoading = false;
  List<Offset?> _points = [];
  List<List<Offset?>> _undoStack = [];
  List<List<Offset?>> _redoStack = [];

  TextEditingController get textController => _textController;
  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;
  Color get pointerColor => _pointerColor;
  XFile? get image => _image;
  bool get isBackground => _isBackground;
  bool get isDrawing => _isDrawing;
  bool get isLoading => _isLoading;
  List<Offset?> get points => _points;

  SignInProvider _signInProvider = SignInProvider();

  clearData(){
    _textController.text = "";
    _backgroundColor = Colors.white;
    _textColor = Colors.black;
    _pointerColor = Colors.black;
    _image = null;
    _isDrawing = false;
    _isBackground = false;
    _points.clear();
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
  }

  pickingImageFromCamera(pickedFile){
    if (pickedFile != null) {
      _image = pickedFile;
      notifyListeners();
    }
  }

  void pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = pickedFile;
      notifyListeners();
    }
  }

  textBackground() {
    _isBackground = !_isBackground;
    _isDrawing = false;
    notifyListeners();
  }

  Future<String> getPersonalFolder() async {
    final downloadsDirectory = await AndroidPathProvider.downloadsPath;
    final personalFolderPath = '$downloadsDirectory/Tiinver App';
    Directory personalFolder = Directory(personalFolderPath);
    if (!await personalFolder.exists()) {
      personalFolder.createSync(recursive: true);
    }
    return personalFolder.path;
  }

  Future<bool> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      await getPersonalFolder();
      return true;
    } else {
      return false;
    }
  }

  void pickColor(Color color) {
    if(_isBackground){
      _textColor = color;
    }else if(_isDrawing){
      _pointerColor = color;
    }else{
      _backgroundColor = color;
    }
    notifyListeners();
  }

  Future<String> generateUniqueFileName(String extension) async {
    final personalFolder = await getPersonalFolder();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$personalFolder/image_$timestamp.$extension';
  }

  Future<String> saveImage(Uint8List imageBytes) async {
    if (await requestPermissions()) {
      final uniqueFileName = await generateUniqueFileName('png');
      final imageFile = File(uniqueFileName);
      await imageFile.writeAsBytes(imageBytes);
      return uniqueFileName;
    } else {
      throw Exception('Storage permission not granted');
    }
  }

  void startDrawing() {
    _isDrawing = !_isDrawing;
    _isBackground = false;
    notifyListeners();
  }

  void addPoint(Offset? point) {
    _points.add(point);
    notifyListeners();
  }

  void clearPoints() {
    _points.clear();
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
  }

  void undo() {
    if (_points.isNotEmpty) {
      _redoStack.add(List.from(_points));
      _points = _undoStack.removeLast();
      notifyListeners();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(List.from(_points));
      _points = _redoStack.removeLast();
      notifyListeners();
    }
  }

  void saveForUndo() {
    _undoStack.add(List.from(_points));
  }

  Future<void> addActivity({
    required String userId,
    required String apiKey,
    required String message,
    required File image,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {

      final body = {
        'actor': userId,
        'verb': "post",
        'object': "photos",
        'object_url': image.readAsBytesSync(),
        'message': message,
      };

      final res = await ApiService.post(
          requestBody: postEncode(body),
          headers: header2(apiKey),
          endPoint: Endpoint.addActivity
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


}
