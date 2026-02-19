import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiinver_project/models/feedTimeLineModel/feed_time_line_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaWidget extends StatelessWidget {
  final Activity activity;
  final List<Activity> activities;
  final int initialIndex;
  final VoidCallback onTap;

  const MediaWidget({
    super.key,
    required this.activity,
    required this.activities,
    required this.initialIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: activity.isVideo()
          ? VideoWidget(activity: activity)
          : Image.network(activity.objectUrl!, fit: BoxFit.cover),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final Activity activity;

  const VideoWidget({super.key, required this.activity});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  String? _thumbnailPath;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    final directory = await getTemporaryDirectory();
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: widget.activity.objectUrl!,
      thumbnailPath: directory.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 300, // specify the height of the thumbnail, maintaining the aspect ratio
      quality: 75,
    );

    if (thumbnailPath != null) {
      setState(() {
        _thumbnailPath = thumbnailPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _thumbnailPath != null
        ? Image.file(File(_thumbnailPath!), fit: BoxFit.cover)
        : Container(
      height: 27.h,
      width: 45.w,
      color: Colors.grey,
    );
  }
}
