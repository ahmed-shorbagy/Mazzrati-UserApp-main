import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? placeholder;

  const CustomImageWidget({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder = Images.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (!image.contains('assets')) {
      // Network image
      return CachedNetworkImage(
        placeholder: (context, url) => Image.asset(
          placeholder ?? Images.placeholder,
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
        imageUrl: image,
        fit: fit ?? BoxFit.cover,
        height: height,
        width: width,
        errorWidget: (context, url, error) => Image.asset(
          placeholder ?? Images.placeholder,
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // Asset image
      return Image.asset(
        image,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      );
    }
  }
}

// Example usage of Images class
