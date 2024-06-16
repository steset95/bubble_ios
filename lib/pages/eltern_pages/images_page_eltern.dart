
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../database/firestore_images.dart';



class ImagesPageEltern extends StatefulWidget {
  final String childcode;
  final String date;


  ImagesPageEltern({
    super.key,
    required this.childcode,
    required this.date,
  });



  @override
  State<ImagesPageEltern> createState() => _ImagesPageElternState();
}

class _ImagesPageElternState extends State<ImagesPageEltern> {

  Future<List<String>> getImagePath(String childcode, String date) async {
    ListResult result =
    await FirebaseStorage.instance.ref('/images/$date/$childcode').listAll();
    return await Future.wait(
      result.items.map((e) async => await e.getDownloadURL()),
    );
  }



  Widget buildGallery(String childcode, String date) {
    return FutureBuilder(
      future: getImagePath(childcode, date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Container(

          child: GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            itemCount: snapshot.data!.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              //childAspectRatio: 100,
              mainAxisExtent: 300,
              //mainAxisSpacing: 10,
              //crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => Image.network(
              snapshot.data![index],
              fit: BoxFit.fitWidth,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child; Text("");
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
    final Storage storage = Storage();
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
            title: Text("Bilder",
              style: TextStyle(color:Colors.black),
            ),
          ),
        body: SingleChildScrollView(
          child:
          Column(
            children: [
              buildGallery(widget.childcode, widget.date)
            ],
          ),


    )
      )
            );
    }
    }






