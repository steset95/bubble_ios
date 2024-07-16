
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';
import 'package:socialmediaapp/components/my_profile_data_read_only.dart';

import '../../components/notification_controller.dart';


class ProvisionPageKita extends StatefulWidget {
  ProvisionPageKita({super.key});



  @override
  State<ProvisionPageKita> createState() => _ProvisionPageKitaState();
}

class _ProvisionPageKitaState extends State<ProvisionPageKita> {


  final currentUser = FirebaseAuth.instance.currentUser;


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





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text("Provision",
          ),

        ),
        // Abfrage der entsprechenden Daten - Sammlung = Users
        body: SingleChildScrollView(

    )
      ),
    );
  }
}



