
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/database/firestore_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../database/firestore_images_profile.dart';


class ImageViewerProfile extends StatefulWidget {
  final String childcode;

  const ImageViewerProfile({
    super.key,
    required this.childcode,

  });

  @override
  State<ImageViewerProfile> createState() => _ImageViewerProfileState();
}

/*

Zum Anzeigen ImageViewerProfile(),

 */

final currentUser = FirebaseAuth.instance.currentUser;

class _ImageViewerProfileState extends State<ImageViewerProfile> {
  @override
  Widget build(BuildContext context) {
    final StorageProfile storage = StorageProfile();
    final childcode = widget.childcode;
    return Row(
          children: [
            FutureBuilder(
                future: storage.downloadURL(
                    '/profile/$childcode/Profilbild'),
                builder: (BuildContext context,
                    AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(45), // Image radius
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return Container();
                  }
                  return Container();
                }
            ),
          ],
        );

  }
}

