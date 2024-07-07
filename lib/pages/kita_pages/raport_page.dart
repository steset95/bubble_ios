import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/my_image_upload_button.dart';
import '../../components/notification_controller.dart';




class RaportPage extends StatefulWidget {
  final String docID;

  RaportPage({
    super.key,
    required this.docID,

  });

  @override
  State<RaportPage> createState() => _RaportPageState();
}

class _RaportPageState extends State<RaportPage> {

  // Text Controller für Abfrage des Inhalts im Textfeld "Raport hinzufügen"
  final _raportTextController = TextEditingController();

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


  // Raport hinzufügen bzw. Allgemeiner Firebase Connect
  void addRaport(String raportTitle, String raportText) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    DateTime now = DateTime.now();
    String uhrzeit = DateFormat('kk:mm').format(now);
    // in Firestore speichern und "Raports" unter "Kinder" erstellen
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(widget.docID)
        .collection(formattedDate)
        .add({
      "RaportTitle" : raportTitle,
      "RaportText" : raportText,
      'TimeStamp': Timestamp.now(),
      "Uhrzeit": uhrzeit,
    });
   }






// Feld anmledung direkt unter "Kinder" anpassen -> Anmelden
  void anmeldungChild(String field, String value) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(widget.docID)
        .update({
      field: value,
      'timestamp': Timestamp.now(),
    });
  }




  /// Dialog für Anmeldung Hinzufügen anzeiegn
  //
  //
  void showRaportDialogAnmeldung() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(now);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Kind Anmelden?",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),

        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              // Raport hinzufügen
              anmeldungChild('anmeldung', 'Anwesend (Seit: $formattedDate)');
              addRaport('Angemeldet', '');
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Bestätigen"),
          ),
        ],
      ),
    );
  }

  // Dialog für Anmeldung Hinzufügen anzeiegn
  //
  //



  /// Dialog für Essen Hinzufügen anzeiegn
  //
  //
  void showRaportDialogEssen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Essen hinzufügen",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content: TextField (
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 20,
          maxLength: 200,
          controller: _raportTextController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Essen..."),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
          },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
              onPressed: () {
                // Raport hinzufügen
                addRaport('Essen: ', _raportTextController.text);
                // Textfeld schliessen
                Navigator.pop(context);
              //Textfeld leeren
                _raportTextController.clear();
              },
              child: Text("Speichern"),
          ),
        ],
      ),
    );
  }

  // Dialog für Essen Hinzufügen anzeiegn
  //
  //


  /// Dialog für Schlafen Hinzufügen anzeiegn
  //
  //



  void showRaportDialogSchlaf() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Schlaf",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        //insetPadding: EdgeInsets.symmetric(horizontal: 100),
        content: TextField (
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 20,
          maxLength: 200,
          controller: _raportTextController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Schlaf..."),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              // Raport hinzufügen
              addRaport('Schlaf: ', _raportTextController.text);
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Speichern"),
          ),
        ],
      ),
    );
  }

  // Dialog für Schlafen Hinzufügen anzeiegn
  //
  //




  /// Dialog für Aktivität Hinzufügen anzeiegn
  //
  //



  void showRaportDialogActivity() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Aktivität hinzufügen",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        //insetPadding: EdgeInsets.symmetric(horizontal: 100),
        content: TextField (
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 20,
          maxLength: 200,
          controller: _raportTextController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Aktivität..."),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              // Raport hinzufügen
              addRaport('Aktivität: ', _raportTextController.text);
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Speichern"),
          ),
        ],
      ),
    );
  }

  // Dialog für Aktivität Hinzufügen anzeiegn
  //
  //


  /// Dialog für Diverses Hinzufügen anzeiegn
  //
  //



  void showRaportDialogDiverses() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Diverses hinzufügen",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        //insetPadding: EdgeInsets.symmetric(horizontal: 100),
        content: TextField (
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 20,
          maxLength: 200,
          controller: _raportTextController,
          autofocus: true,
          decoration: InputDecoration(hintText: "Diverses..."),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              // Raport hinzufügen
              addRaport('Diverses: ', _raportTextController.text);
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Speichern"),
          ),
        ],
      ),
    );
  }

  // Dialog für Diverses Hinzufügen anzeiegn
  //
  //





  /// Dialog für Abholung Hinzufügen anzeiegn
  //
  //
  void showRaportDialogAbmeldung() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(now);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Kind Abmelden?",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          // cancel Button
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Abbrechen"),
          ),

          // save Button
          TextButton(
            onPressed: () {
              // Raport hinzufügen
              anmeldungChild('anmeldung', "Abgemeldet");
              anmeldungChild('abholzeit', "");
              addRaport('Abgemeldet', '');

              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Speichern"),
          ),
        ],
      ),
    );
  }

  // Dialog für Abholung Hinzufügen anzeiegn
  //
  //


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.black,
              height: 1.0,
            ),
          ),
          title: Text("Tagesraport",
            style: TextStyle(color:Colors.black),
          ),
        ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: showRaportDialogAnmeldung,
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.door_back_door_outlined ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Anmeldung"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: showRaportDialogEssen,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          height: 140,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.local_pizza_outlined),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Essen"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: showRaportDialogSchlaf,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          height: 140,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bed_outlined),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Schlafen"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: showRaportDialogActivity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          height: 140,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sports_soccer),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Aktivitäten"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: showRaportDialogDiverses,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          height: 140,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.note_add_outlined),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Diverses"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: showRaportDialogAbmeldung,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          height: 140,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.family_restroom),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Abholung"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (kIsWeb == false)
                Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
              const SizedBox(height: 20),
              ImageUpload(docID: widget.docID),
            ],
        ),
      ),
            ],
          ),
      ),
    );
  }
}
