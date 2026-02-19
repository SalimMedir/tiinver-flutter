import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/text_widget.dart';
import 'package:tiinver_project/providers/graphic/graphic_provider.dart';
import 'package:tiinver_project/screens/app_screens/addActivityScreen/add_activity_screen.dart';

import '../../../constants/colors.dart';
import '../../../constants/images_path.dart';
import '../../../models/chatModel/chat_model.dart';
import '../../../models/msgModel/msg_model.dart';
import '../../../providers/graphic/comp/drawiing_paint.dart';
import '../../../providers/uploadingProgressProvider/uploading_progress_provider.dart';

class GraphicScreen extends StatelessWidget {
  GraphicScreen({super.key,this.user ,required this.isCamera});
  bool isCamera;
  ChatUser? user;
  List<Message> _list = [];
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var graphicP = Provider.of<GraphicProvider>(context, listen: false);
    var uploadingProgressBarProvider = Provider.of<UploadingProgressBarProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(10),
              child: Image.asset(
                ImagesPath.personIcon,
                color: bgColor,
              )),
          actions: [
            IconButton(
              icon: Icon(Icons.undo, color: bgColor),
              onPressed: () {
                graphicP.undo();
              },
            ),
            IconButton(
              icon: Icon(Icons.redo, color: bgColor),
              onPressed: () {
                graphicP.redo();
              },
            ),
            InkWell(
              onTap: () {
                Get.back();
                graphicP.clearData();
              },
              child: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    ImagesPath.cancelIcon,
                    color: bgColor,
                  )),
            ),
            SizedBox(width: 15)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<GraphicProvider>(
                builder: (context, value, child) {
                  return RepaintBoundary(
                    key: _repaintBoundaryKey,
                    child: GestureDetector(
                      onPanStart: (details) {
                        graphicP.saveForUndo();
                      },
                      onPanUpdate: (details) {
                        if (graphicP.isDrawing) {
                          RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                          Offset point =
                          renderBox.globalToLocal(details.globalPosition);
                          graphicP.addPoint(point);
                        }
                      },
                      onPanEnd: (details) {
                        graphicP.addPoint(null);
                      },
                      child: Container(
                        height: 85.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: context
                              .watch<GraphicProvider>()
                              .backgroundColor,
                        ),
                        child: Stack(
                          children: [
                            context.watch<GraphicProvider>().image != null
                                ? Positioned.fill(
                              child: Image.file(
                                File(context
                                    .watch<GraphicProvider>()
                                    .image!
                                    .path),
                                fit: BoxFit.cover,
                              ),
                            )
                                : Container(),
                            value.isDrawing ? CustomPaint(
                              painter: DrawingPainter(
                                  context.watch<GraphicProvider>().points,
                                context.watch<GraphicProvider>().pointerColor,
                              ),
                            )
                                : SizedBox(),
                            Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: value.isBackground ? Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: context
                                              .watch<GraphicProvider>()
                                              .isBackground
                                              ? bgColor
                                              : Colors.transparent,
                                          borderRadius:
                                          BorderRadius.circular(15)),
                                      child: TextField(
                                        controller: context
                                            .watch<GraphicProvider>()
                                            .textController,
                                        autofocus: value.isBackground,
                                        decoration: InputDecoration(
                                          hintText: 'Type here...',
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: value.textColor),
                                        maxLines: null,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                        : SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                child: Container(
                  height: 10.h,
                  width: 100.w,
                  decoration: BoxDecoration(color: bgColor),
                  child: Consumer<GraphicProvider>(builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            _pickColor(context);
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: themeColor, shape: BoxShape.circle),
                            child: Center(
                              child: Image.asset(
                                ImagesPath.paintingIcon,
                                height: 25,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    graphicP.textBackground();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: value.isBackground ? lightGreyColor : themeColor,
                                    child: Image.asset(
                                      ImagesPath.fontIcon,
                                      height: 25,
                                    ),
                                  )),
                              InkWell(
                                  onTap: () {
                                    graphicP.startDrawing();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: graphicP.isDrawing ? lightGreyColor : themeColor,
                                    child: Image.asset(
                                      ImagesPath.pencilIcon,
                                      height: 25,
                                    ),
                                  )),
                              CircleAvatar(
                                backgroundColor: themeColor,
                                child: Image.asset(
                                  ImagesPath.smileIcon,
                                  height: 25,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: themeColor,
                                child: Image.asset(
                                  ImagesPath.addIcon,
                                  height: 25,
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    context.read<GraphicProvider>().pickImage();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: themeColor,
                                    child: Image.asset(
                                      ImagesPath.galleryIcon,
                                      height: 25,
                                      color: bgColor,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if(isCamera){
                              _sendPost(context);
                            }else{
                              _saveImage(context).whenComplete((){
                                graphicP.clearData();
                              });
                            }
                            // Get.back();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: themeColor, shape: BoxShape.circle),
                            child: Center(
                              child: Image.asset(
                                ImagesPath.sendIcon,
                                height: 25,
                                color: bgColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: TextWidget1(
              text: 'Pick a color!',
              fontSize: 16.dp,
              fontWeight: FontWeight.w700,
              isTextCenter: false,
              textColor: textColor
          ),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: context.read<GraphicProvider>().backgroundColor,
              onColorChanged: (color) {
                context.read<GraphicProvider>().pickColor(color);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    var uploadingProgressBarProvider = Provider.of<UploadingProgressBarProvider>(context, listen: false);
    try {
      uploadingProgressBarProvider.setVisibility(true);
      RenderRepaintBoundary boundary =
      _repaintBoundaryKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        String imagePath =
        await context.read<GraphicProvider>().saveImage(pngBytes);
        // await FirebaseChat.sendChatImage(_list, user!, File(imagePath));
        Get.back();
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Image saved to $imagePath')));
      }
    } catch (e) {
      print(e);
    } finally{
      uploadingProgressBarProvider.setVisibility(false);

    }
  }

  Future<void> _sendPost(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
      _repaintBoundaryKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        String imagePath =
        await context.read<GraphicProvider>().saveImage(pngBytes);
        Get.to(()=>AddActivityScreen(imageFilePath: File(imagePath)));
        // await FirebaseChat.sendChatImage(_list, user!, File(imagePath));
        // Get.back();
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Image saved to $imagePath')));
      }
    } catch (e) {
      print(e);
    }
  }
}
