/*
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';



class ImageUpload extends StatefulWidget {

  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'images/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (pickedFile != null)
          Expanded(
              child: Container(
                child: Center(
                  child: Text(pickedFile!.name),
                ),

              )
          ),
        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: selectFile,
            child: Text("Bild auswählen")
        ),
        ElevatedButton(
            onPressed: uploadFile,
            child: Text("Bild hochladen")
        ),
      ],
    );
  }
}

 */