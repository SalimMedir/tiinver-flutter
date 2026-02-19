import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiinver_project/constants/images_path.dart';

class ImageLoaderWidget extends StatelessWidget {
  final String imageUrl;
  const ImageLoaderWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Image.asset(ImagesPath.person), // Path to your placeholder image
      errorWidget: (context, url, error) => Image.asset(ImagesPath.person), // Display an error icon if the image fails to load
      fit: BoxFit.cover,
    );
  }
}
