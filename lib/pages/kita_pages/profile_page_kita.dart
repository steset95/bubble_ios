
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

import '../../components/notification_controller.dart';


class ProfilePageKita extends StatefulWidget {
  ProfilePageKita({super.key});



  @override
  State<ProfilePageKita> createState() => _ProfilePageKitaState();
}

class _ProfilePageKitaState extends State<ProfilePageKita> {


  final currentUser = FirebaseAuth.instance.currentUser;


  // Referenz zu "Users" Datenbank
  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Notification
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => NotificationController().notificationCheck());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  /// Notification



// Bearbeitungsfeld
  Future<void> editField(String field, String titel, String text) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "$titel",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
          //"Edit $field",
        ),
        content: TextFormField(
          initialValue: text,
          autofocus: true,
          onChanged: (value){
            newValue = value;
          },
        ),
        actions: [
          // Cancel Button
          TextButton(
            child: const Text("Abbrechen",
            ),
            onPressed: () => Navigator.pop(context),
          ),
          //Save Button
          TextButton(
            child: const Text("Speichern",
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );

    // prüfen ob etwas geschrieben
    if (newValue.trim().length > 0) {
      // In Firestore updaten
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }


  Future logOut()  async {
    await _firebaseAuth.signOut();
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
              height: 1.0,
            ),
          ),
          title: Text("Profil",
            style: TextStyle(color:Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: logOut,
              icon: const Icon(Icons.logout),
            ),
            const SizedBox(width: 20),
          ],
        ),

        // Abfrage der entsprechenden Daten - Sammlung = Users
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser?.email)
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
          
                // Inhalt Daten
          
                return
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      ProfileData(
                        text: userData["username"],
                        sectionName: "Name",
                        onPressed: () => editField("username", "Name", userData["username"]),
                      ),
          
                      ProfileData(
                        text: userData["email"],
                        sectionName: "Email-Adresse",
                        onPressed: () => editField("email", "Email-Adresse", userData["email"]),
                      ),
                      ProfileData(
                        text: userData["adress"],
                        sectionName: "Strasse und Hausnummer",
                        onPressed: () => editField("adress", "Strasse und Hausnummer", userData["adress"]),
                      ),
          
                      ProfileData(
                        text: userData["adress2"],
                        sectionName: "PLZ und Ort",
                        onPressed: () => editField("adress2", "PLZ und Ort", userData["adress2"]),
                      ),
          
                      ProfileData(
                        text: userData["tel"],
                        sectionName: "Telefonnummer",
                        onPressed: () => editField("tel", "Telefonnummer", userData["tel"]),
                      ),

                      ProfileData(
                        text: userData["iban"],
                        sectionName: "IBAN",
                        onPressed: () => editField("iban", "IBAN", userData["iban"]),
                      ),
          
                      SizedBox(
                        height: 30,
                      ),
                      Text("Guthaben"),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(100))
                          ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text (userData["guthaben"].toString()),
                              ],
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: 20,
                      ),

                    ],
                  );
                // Fehlermeldung wenn nichts vorhanden ist
              } else {
                return const Text("Keine Daten vorhanden");
              }
            },
          ),
        ),
      ),
    );
  }
}



