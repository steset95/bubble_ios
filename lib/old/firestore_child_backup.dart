
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirestoreDatabaseChild {

  // get Collection of children
  final CollectionReference children = FirebaseFirestore.instance.collection("Kinder");

  final CollectionReference raports = FirebaseFirestore.instance.collection("Raports");

  final currentUser = FirebaseAuth.instance.currentUser;





  // CREATE: add new Child Data
Future<void>addChild(String child) {
  final fromkita = currentUser?.email;
  return children.add({
    'child': child,
    'fromkita': fromkita,
    'timestamp': Timestamp.now(),
  });

}


  // READ: get Child-Data from Database

Stream<QuerySnapshot> getChildrenStream() {
  final childrenStream =
  // Nach Timestamp ordnen
  children.orderBy('timestamp', descending: true).snapshots();

  return childrenStream;

}

// Daten ändern


  Future<void> updateChild(String docID, String newChild) {
  return children.doc(docID).update({
    'child': newChild,
    'timestamp': Timestamp.now(),
  });
}

// Daten löschen
Future<void> deleteChild(String docID)  {
  return children
      .doc(docID)
      .delete();
}

}

*/