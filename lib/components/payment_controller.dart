
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/eltern_pages/bezahlung_page_eltern.dart';




class PaymentController {

  final currentUser = FirebaseAuth.instance.currentUser;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();





  void daysleftCheck() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) {
      DateTime aboBis = document["aboBis"].toDate();


      /*
      DateTime aboBis = date.add(Duration(days:aboDauer));

      DateTime a = aboBis;
      DateTime b = DateTime.now();
      Duration difference = b.difference(a);


       */

      if (document["aboBis"].toDate().isBefore(DateTime.now())) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .update({"adress": "7"});
      }
    });
  }
        }




