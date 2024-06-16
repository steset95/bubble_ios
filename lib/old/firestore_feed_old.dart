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

/*
class FirestoreDatabaseFeed{

  // aktuell eingeloggter User abfragen

  User? user = FirebaseAuth.instance.currentUser;

  // Kollektion der Posts von Firebase abholen
  final CollectionReference posts =
  FirebaseFirestore.instance.collection('Posts');
  // Nachricht Posten
  Future<void> addPost(String message) {
    return posts.add(
        {
          'UserEmail': user!.email,
          'PostMessage': message,
          'TimeStamp': Timestamp.now(),
        });

  }

  // Lesen der Posts von Datenbank

  Stream<QuerySnapshot> getPostsStream() {
    final postStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postStream;
  }
}

*/