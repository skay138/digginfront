import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUpload extends StatefulWidget {
  const ImageUpload(
      {super.key, required this.whichImage, required this.setImage});
  final File? whichImage;
  final Function setImage;
  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final picker = ImagePicker();

  imageFromGallery() async {
    var image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    if (image != null) {
      widget.setImage(widget.whichImage, File(image.path));
    }
  }

  imageFromCamera() async {
    var image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    if (image != null) {
      widget.setImage(widget.whichImage, File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: (widget.whichImage != null)
                ? Image.file(
                    widget.whichImage!,
                    width: 200,
                  )
                : const Text('이미지를 선택해주세요'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: imageFromCamera,
                icon: const Icon(Icons.camera_alt_rounded),
              ),
              IconButton(
                onPressed: imageFromGallery,
                icon: const Icon(Icons.photo),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
    );
  }
}
