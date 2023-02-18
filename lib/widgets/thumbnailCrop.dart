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
      clipper: _ThumbnailClipper(width: width, height: height),
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
  final double width;
  final double height;

  _ThumbnailClipper({
    required this.width,
    required this.height,
  });

  @override
  Rect getClip(Size size) {
    return Rect.fromCenter(
      center: Offset(width / 2, height / 2),
      width: width - width * 0.3,
      height: height - height * 0.3,
    );
  }

  @override
  bool shouldReclip(_ThumbnailClipper oldClipper) => false;
}
