
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

import '../../components/my_image_delete_button.dart';
import '../../components/my_profile_data_read_only.dart';
import '../../database/firestore_child.dart';



class ImagesPageKita extends StatefulWidget {
  final String docID;

  ImagesPageKita({
    super.key,
    required this.docID
  });



  @override
  State<ImagesPageKita> createState() => _ImagesPageKitaState();
}

class _ImagesPageKitaState extends State<ImagesPageKita> {



  Future<List<String>> getImagePath(String docID, ) async {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    ListResult result =
    await FirebaseStorage.instance.ref('/images/$formattedDate/$docID').listAll();
    return await Future.wait(
      result.items.map((e) async => await e.getDownloadURL()),
    );
  }

  Widget buildGallery(String docID) {
    return FutureBuilder(
      future: getImagePath(docID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Container(

          child:
            GridView.builder(
            physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => Image.network(
              snapshot.data![index],
              fit: BoxFit.fitHeight,
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

            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.black,
                height: 2.0,
              ),
            ),
            title: Text("Bilder heute",
              style: TextStyle(color:Colors.black),
            ),
          ),
        body: SingleChildScrollView(

          child:
          Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        child: ImageDelete(docID: widget.docID),
                      ),
                      Text("Bilder löschen",
                        style: TextStyle(color:Colors.black),
                      ),
                    ],
                  ),

                ],
              ),
              const SizedBox(height: 20),
              buildGallery(widget.docID),

            ],
          )


    )
      )
            );
    }
    }






