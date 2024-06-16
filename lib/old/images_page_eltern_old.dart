/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../components/my_image_viewer.dart';



class ImagesPageEltern extends StatefulWidget {
  final String childcode;

  ImagesPageEltern({
    super.key,
    required this.childcode
  });


  @override
  State<ImagesPageEltern> createState() => _ImagesPageElternState();
}

class _ImagesPageElternState extends State<ImagesPageEltern> {





  Future<List<String>> getImagePath(String childcode) async {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    ListResult result =
    await FirebaseStorage.instance.ref('/images/$formattedDate/$childcode').listAll();
    return await Future.wait(
      result.items.map((e) async => await e.getDownloadURL()),
    );
  }

  Widget buildGallery() {
    return FutureBuilder(
      future: getImagePath(widget.childcode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Container(
          width: 300,
          height: 800,
          child: GridView.builder(
            itemCount: snapshot.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 100,
              mainAxisExtent: 500,
              mainAxisSpacing: 30,

            ),
            itemBuilder: (context, index) => Image.network(
              snapshot.data![index],
              fit: BoxFit.scaleDown,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Infos Kind"),
        ),
        body: SingleChildScrollView(
          child:
          buildGallery()
    ),
      )
            );
    }
    }


*/



