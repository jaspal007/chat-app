import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key});

  @override
  State<UserImagePicker> createState() => UserImagePickerState();
}

class UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageFile;
  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) return;
    setState(() {
      pickedImageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          foregroundImage:
              pickedImageFile != null ? FileImage(pickedImageFile!) : null,
        ),
        Positioned(
          top: 60,
          left: 55,
          child: IconButton(
            onPressed: pickImage,
            icon: const Icon(
              Icons.add_a_photo_rounded,
            ),
          ),
        ),
      ],
    );
  }
}
