import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*

Diese Datenbank speichert Posts von User die Sie auf dem App veröffentlicht haben.
Sie werden in einer Kollektion namens "Posts" in Firebase abgespeichert.

Jeder Post beinhaltet:

- eine Nachricht
- Email von User
- Zeitstempfel

 */




class FirestoreDatabaseFeed {

  // aktuell eingeloggter User abfragen

  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference posts =
  FirebaseFirestore.instance.collection("Feed");

  final CollectionReference users =
  FirebaseFirestore.instance.collection("Users");

  /// Extern

  void addPostExt(String title, String content) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.email)
        .collection("Feed_Extern")
        .add({
      'titel': title,
      'inhalt': content,
      'TimeStamp': Timestamp.now(),
    });
  }


  // Lesen der Posts von Datenbank

  Stream<QuerySnapshot> getPostsStreamExt() {
    final postStreamExt = FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.email)
        .collection("Feed_Extern")
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postStreamExt;
  }


  /// Intern

  void addPostInt(String title, String content) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.email)
        .collection("Feed_Intern")
        .add({
      'titel': title,
      'inhalt': content,
      'TimeStamp': Timestamp.now(),
    });
  }


// Lesen der Posts von Datenbank

  Stream<QuerySnapshot> getPostsStreamInt() {
    final postStreamInt = FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.email)
        .collection("Feed_Intern")
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postStreamInt;
  }



  /// Eltern

  Stream<QuerySnapshot> getPostsStreamEltern(String kitaMail) {
    final postStreamExt = FirebaseFirestore.instance
        .collection("Users")
        .doc(kitaMail)
        .collection("Feed_Extern")
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postStreamExt;
  }




}