import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImageCustom extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  CachedImageCustom(this.imageUrl, {this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        return Container(
          color: Colors.grey,
          child: Center(
            child: Text('No Image'),
          ),
        );
      },
      placeholder: (context, url) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurpleAccent,
            strokeWidth: 3,
          ),
        );
      },
    );
  }
}
