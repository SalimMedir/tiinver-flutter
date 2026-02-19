import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/providers/graphic/graphic_provider.dart';
import 'package:tiinver_project/widgets/submit_button.dart';

import '../graphicScreen/graphic_screen.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photo(
          pathBuilder: (sensors) async {
            final extDir = await AndroidPathProvider.downloadsPath;
            final testDir = await Directory(
              '$extDir/camerawesome',
            ).create(recursive: true);
            if (sensors.length == 1) {
              final String filePath =
                  '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
              return SingleCaptureRequest(filePath, sensors.first);
            } else {
              // Separate pictures taken with front and back camera
              return MultipleCaptureRequest(
                {
                  for (final sensor in sensors)
                    sensor:
                    '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
                },
              );
            }
          },
        ),
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.back),
          flashMode: FlashMode.auto,
          aspectRatio: CameraAspectRatios.ratio_4_3,
          zoom: 0.0,
        ),
        enablePhysicalButton: true,
        previewAlignment: Alignment.center,
        previewFit: CameraPreviewFit.contain,
        onMediaTap: (mediaCapture) {
          mediaCapture.captureRequest.when(
            single: (single) {
              debugPrint('single: ${single.file?.path}');
              if (single.file != null) {
                Get.to(()=>ImageViewer(filePath: single.file!.path));
              }
            },
            multiple: (multiple) {
              multiple.fileBySensor.forEach((key, value) {
                debugPrint('multiple file taken: $key ${value?.path}');
                if (value != null) {
                  Get.to(()=>ImageViewer(filePath: value.path));
                }
              });
            },
          );
        },
        availableFilters: awesomePresetFiltersList,
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  ImageViewer({super.key, required this.filePath});

  String filePath;

  @override
  Widget build(BuildContext context) {
    var graphicP = Provider.of<GraphicProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: textColor,
      appBar: AppBar(
        backgroundColor: textColor,
        surfaceTintColor: textColor,
        actions: [
          SubmitButton(
              width: 20.w,
              title: "Next", press: (){
                graphicP.pickingImageFromCamera(XFile(filePath));
                Get.to(()=>GraphicScreen(isCamera: true,));
          }),
          SizedBox(width: 20,),
        ],
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: EdgeInsets.all(8.0),
        color: Colors.black.withOpacity(0.7),
        child: Image.file(
          File(filePath),
          width: 100.w,
          height: 100.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
