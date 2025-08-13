import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditableImage extends StatefulWidget {
  final ImageProvider image;
  final ValueChanged<String> onChange;
  final Function()? onTap;

  const EditableImage({
    super.key,
    required this.image,
    required this.onChange,
    this.onTap,
  });

  @override
  State<EditableImage> createState() => _EditableImageState();
}

class _EditableImageState extends State<EditableImage> {
  late ImageProvider _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.image;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final newImage = FileImage(File(pickedFile.path));
      setState(() {
        _currentImage = newImage;
      });
      widget.onChange(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Image(image: _currentImage, fit: BoxFit.cover),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _pickImage,
            tooltip: 'Edit Image',
          ),
        ),
      ],
    );
  }
}
