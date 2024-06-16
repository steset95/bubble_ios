

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:socialmediaapp/database/firestore_images.dart';

import '../helper/helper_functions.dart';


class ImageUpload extends StatefulWidget {
  final String docID;

  const ImageUpload({
    super.key,
    required this.docID
  });


  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

/*

Für Upload:  ImageUpload(),

 */

final currentUser = FirebaseAuth.instance.currentUser;


class _ImageUploadState extends State<ImageUpload> {




  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Expanded(
      child:
        GestureDetector(
            onTap: () async {
              final results = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: ['png', 'jpg'],
              );
              if (results == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("No Image selected")
                ),
                );
                return null;
              }


              final List<String?> filePaths = results.paths!;
              for (String? path in filePaths) {
                final fileName = path?.split('/').last;
                final docID = widget.docID;

              storage.uploadFile(path!, fileName!, docID);

              }
              Navigator.pop(context);
              displayMessageToUser("Bilder werden hochgeladen...", context);

            },

          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 80,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Bilder"),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}
