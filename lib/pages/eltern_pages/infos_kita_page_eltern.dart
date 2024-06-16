
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../components/my_profile_data_read_only.dart';








class InfosKitaPageEltern extends StatefulWidget {
  final String kitamail;

  InfosKitaPageEltern({
    super.key,
    required this.kitamail
  });



  @override
  State<InfosKitaPageEltern> createState() => _InfosKitaPageElternState();
}

class _InfosKitaPageElternState extends State<InfosKitaPageEltern> {


  final currentUser = FirebaseAuth.instance.currentUser;


  final kinderCollection = FirebaseFirestore
      .instance
      .collection("Kinder"
  );



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
            title: Text("Infos Kita",
              style: TextStyle(color:Colors.black),
            ),
          ),
        body: SingleChildScrollView(
          child:
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(widget.kitamail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final username = snapshot.data!['username'];
                final adress = snapshot.data!['adress'];
                final adress2 = snapshot.data!['adress2'];
                final tel = snapshot.data!['tel'];

                return
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ProfileDataReadOnly(
                          text: username,
                          sectionName: "Name",
                        ),
                        ProfileDataReadOnly(
                          text: adress,
                          sectionName: "Adresse",
                        ),
                        ProfileDataReadOnly(
                          text: adress2,
                          sectionName: "Ort",
                        ),
                        ProfileDataReadOnly(
                          text: tel,
                          sectionName: "Telefonnummer",
                        ),
                      ],
                    ),
                  );
              };
              return const Text("");
            },
          ),
    )
      )
            );
    }
    }






