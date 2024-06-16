

 /* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FirestoreDatabaseEmail {





  final currentUser = FirebaseAuth.instance.currentUser;




  void getEmailKita(String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        String email = document['kita'];
        return email;
      }
    }
      );
  }


  String getEmailEltern(String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .get()
        .then((DocumentSnapshot document)  {
         String email =  document['eltern'];

         return email;
    }
    );
    return "eltern666@gmail.com";
  }




}


*/