import 'package:flutter/material.dart';

class ThumbnailCrop extends StatelessWidget {
  final String thumbnailUrl;
  final double width;
  final double height;

  const ThumbnailCrop({
    Key? key,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      clipper: _ThumbnailClipper(),
      child: Image.network(
        thumbnailUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ThumbnailClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // 640 x 480
    return Rect.fromCenter(
      center: const Offset(151, 151),
      width: 220,
      height: 220,
    );
  }

  @override
  bool shouldReclip(_ThumbnailClipper oldClipper) => false;
}
