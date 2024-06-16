
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

import '../../components/my_profile_data_read_only.dart';
import '../../database/firestore_get_email.dart';







class InfosElternPageKita extends StatefulWidget {
  final String docID;

  InfosElternPageKita({
    super.key,
    required this.docID
  });



  @override
  State<InfosElternPageKita> createState() => _InfosElternPageKitaState();
}

class _InfosElternPageKitaState extends State<InfosElternPageKita> {


  final currentUser = FirebaseAuth.instance.currentUser;


  final kinderCollection = FirebaseFirestore
      .instance
      .collection("Kinder"
  );

  /*
  final FirestoreDatabaseEmail _emailService = FirestoreDatabaseEmail();
  final eltern = _emailService.getEmailEltern(widget.docID);
  */



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
            title: Text("Eltern",
              style: TextStyle(color:Colors.black),
            ),
          ),
        body: SingleChildScrollView(
          child:
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Kinder")
                  .doc(widget.docID)
                  .snapshots(),
              builder: (context, snapshot)
              {
                // ladekreis
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // Fehlermeldung
                else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                }
                // Daten abfragen funktioniert
                else if (snapshot.hasData) {
              // Entsprechende Daten extrahieren
              final userData = snapshot.data?.data() as Map<String, dynamic>;

              if (userData["eltern"] == "")
              {
              return Text("Kind wurde noch nicht zugeordnet.");
              }

            else {
              final elternmail = userData["eltern"];

              // Inhalt Daten

              return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(elternmail)
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
                SizedBox(
                  height: 15,
                ),
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
              );
              }
                  // Fehlermeldung wenn nichts vorhanden ist
                } else {
                  return const Text("Keine Daten vorhanden");
                }
                return Text("");
              },
    )
    )
      )
            );
    }
    }






