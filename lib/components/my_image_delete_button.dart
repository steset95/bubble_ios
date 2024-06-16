

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:socialmediaapp/database/firestore_images.dart';

import '../helper/helper_functions.dart';


class ImageDelete extends StatefulWidget {
  final String docID;

  const ImageDelete({
    super.key,
    required this.docID
  });


  @override
  State<ImageDelete> createState() => _ImageDeleteState();
}

/*

Für Upload:  ImageUpload(),

 */

final currentUser = FirebaseAuth.instance.currentUser;


class _ImageDeleteState extends State<ImageDelete> {




  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Row(
      children: [
        IconButton(
            onPressed: () async {
              storage.deleteImages(widget.docID);
              Navigator.pop(context);
              return displayMessageToUser("Bilder werden gelöscht......", context);
            },

          icon: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.primary,
          size: 60.0,
          ),
        ),
      ],
    );
  }
}
