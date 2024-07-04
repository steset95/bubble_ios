import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/database/firestore_child.dart';
import 'package:socialmediaapp/old/change_group_page_kita.dart';
import 'package:socialmediaapp/pages/chat_page.dart';
import 'package:socialmediaapp/pages/kita_pages/child_overview_page_kita.dart';
import 'package:socialmediaapp/pages/kita_pages/raport_page.dart';

import '../../components/notification_controller.dart';


class ChildrenPageKita extends StatefulWidget {

  ChildrenPageKita({super.key});

  @override
  State<ChildrenPageKita> createState() => _ChildrenPageKitaState();
}

class _ChildrenPageKitaState extends State<ChildrenPageKita> {

  // Verweis auf FirestoreDatabaseChild

  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

 // Text Controller für Abfrage des Inhalts im Textfeld

  final TextEditingController textController = TextEditingController();


  final usersCollection = FirebaseFirestore
      .instance
      .collection("Users"
  );

  // Gruppen
  var options = [
    '1',
    '2',
    '3',
  ];

  var _currentItemSelected = '1';
  var group = '1';


  bool showProgress = false;
  bool visible = false;
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


  /// Kind hinzufügen Altert Dialog

  void openChildBoxNew({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Text Eingabe
        content: TextField(
          decoration: InputDecoration(hintText: "Vorname, Nachname"),
          //Abfrage Inhalt Textfeld - oben definiert
          controller: textController,
          autofocus: true,
        ),
        actions: [
          TextButton(
            child: const Text("Abbrechen",
            ),
            onPressed: () => Navigator.pop(context),
          ),
          // Speicher Button
          TextButton(
            onPressed: () {
                firestoreDatabaseChild.addChild(textController.text, "1");
              // Textfeld leeren nach Eingabe
              textController.clear();
              //Box schliessen
              Navigator.pop(context);
            },
            child: Text("Kind hinzufügen"),
          )
        ],
      ),
    );
  }

  void openChildBoxDelete({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Löschen bestätigen?"
          ),
        actions: [
          TextButton(
            onPressed: () {
              firestoreDatabaseChild.deleteChild(docID!);
              Navigator.pop(context);
            },
            child: Text("Löschen"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Abbrechen"),
          )
        ],
      ),
    );
  }




/// Gruppe ändern Altert Dialog

  void openChildBoxGroup({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
      // Text Eingabe
      content: DropdownButtonFormField<String>(
        //dropdownColor: Colors.blue[900],
        isDense: true,
        isExpanded: false,
        //iconEnabledColor: Colors.black,
        //focusColor: Colors.black,

        items: options.map((String dropDownStringItem) {
          return DropdownMenuItem<String>(
            value: dropDownStringItem,
            child: Text(
              dropDownStringItem,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
        }).toList(),
        value: _currentItemSelected, onChanged: (newValueSelected) {
        setState(() {
          _currentItemSelected = newValueSelected!;
          group = newValueSelected;
        });
      },
      ),
      actions: [
        // Speicher Button
        TextButton(
            onPressed: () {

              // Button wird für hinzufügen(unten) und anpassen (neben Kind) genutzt, daher wird zuerst geprüft ob
              // es um einen bestehenden oder neuen Datensatz geht
              if (docID != null) {
                // Child Datensatz hinzufügen
                // Verweis auf "firestoreDatabaseChild" Widget in "firestore_child.dart" File
                // auf die Funktion "addChild" welche dort angelegt ist
                // TextController wurde oben definiert und fragt den Text im Textfeld ab
                firestoreDatabaseChild.updateChild(docID, _currentItemSelected);
              }
              //Box schliessen
              Navigator.pop(context);
            },
            child: Text("Gruppe ändern"),
        )
        ],
        ),
    );
  }

bool isVisible = false;
  Widget? selectedOption;


var buttons = '1';




  Future<void> editField(String field, String titel, String text) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "$titel",
          //"Edit $field",
        ),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: text,
          ),
          maxLength: 12,
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


  void notificationNullKind(String docID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .update({"shownotification": "0"});
  }



/// Start Widget


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 1.0,
          ),
        ),
        title: Text("Kinder",
          style: TextStyle(color:Colors.black),
        ),
      ),


      /// Neus Kind Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: openChildBoxNew,
        child: const Icon(Icons.add_reaction_outlined),
      ),
      /// Anzeige 3 Gruppen

      body:
      StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Entsprechende Daten extrahieren
              final userData = snapshot.data?.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,),
                  child: Column(
                    children: [
                      if (buttons == '1')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = optiona();
                                  });
                                  buttons = '1';
                                },

                                child: optionCards(
                                        userData["gruppe1"],
                                        "assets/icons/recycle.png", context, "1",
                                        Colors.blueAccent),
                                ),

                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = optionb();
                                  });
                                  buttons = '2';
                                },
                                child: optionCards(
                                    userData["gruppe2"], "assets/icons/tools.png",
                                    context, "2", Theme
                                    .of(context)
                                    .colorScheme
                                    .primary)
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = optionc();
                                  });
                                  buttons = '3';
                                },
                                child: optionCards(
                                    userData["gruppe3"], "assets/icons/file.png",
                                    context, "3", Theme
                                    .of(context)
                                    .colorScheme
                                    .primary)
                            ),
                          ],
                        ),


                      if (buttons == '2')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = optiona();
                                  });
                                  buttons = '1';
                                },

                                child: optionCards(
                                    userData["gruppe1"], "assets/icons/recycle.png",
                                    context, "1", Theme
                                    .of(context)
                                    .colorScheme
                                    .primary)
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = optionb();
                                  });
                                  buttons = '2';
                                },
                                child: optionCards(
                                    userData["gruppe2"], "assets/icons/tools.png",
                                    context, "2", Colors.blueAccent)
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = optionc();
                                  });
                                  buttons = '3';
                                },
                                child: optionCards(
                                    userData["gruppe3"], "assets/icons/file.png",
                                    context, "3", Theme
                                    .of(context)
                                    .colorScheme
                                    .primary)
                            ),
                          ],
                        ),


                      if (buttons == '3')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = optiona();
                                  });
                                  buttons = '1';
                                },

                                child: optionCards(
                                    userData["gruppe1"], "assets/icons/recycle.png",
                                    context, "1", Theme
                                    .of(context)
                                    .colorScheme
                                    .primary)
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = optionb();
                                  });
                                  buttons = '2';
                                },
                                child: optionCards(
                                    userData["gruppe2"], "assets/icons/tools.png",
                                    context, "2", Theme
                                    .of(context)
                                    .colorScheme
                                    .primary)
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOption = optionc();
                                  });
                                  buttons = '3';
                                },
                                child: optionCards(
                                    userData["gruppe3"], "assets/icons/file.png",
                                    context, "3", Colors.blueAccent)
                            ),
                          ],
                        ),


                      // options
                      if(selectedOption != null) selectedOption!
                      else
                        optiona(),
                    ],
                  ),
                ),
              );
            }
            return Text("");
          }
      ),

    );

  }

  /// Funktion 3 Gruppen

  Widget optionCards(
      String text, String assetImage, BuildContext context, String cardId, var color,) {
    return
      Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => editField('gruppe$cardId', "Name anpassen", text),
                      icon: Icon(Icons.edit,
                        color: Colors.white,
                        size: 12.0,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Icon(Icons.group,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        text,
                        style: TextStyle(color: Colors.white,
                        fontSize: 10
                        ),
                      ),
                    ],
                  ),
                ],
              ),



            ],
          ),
        ),
      );
  }


  /// 3 Gruppen


  Widget optiona() {
    final mediaQuery = MediaQuery.of(context);
    return
      Column(
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: mediaQuery.size.width * 1,
                height: mediaQuery.size.height * 0.65,
                child: StreamBuilder<QuerySnapshot>(
                // Abfrage des definierten Streams in firestoreDatabaseChild, Stream = getChildrenStream
                  stream: firestoreDatabaseChild.getChildrenStream1(),
                  builder: (context, snapshot){
                    // wenn Daten vorhanden _> gib alle Daten aus
                    if (snapshot.hasData) {
                      List childrenList = snapshot.data!.docs;
                      //als Liste wiedergeben
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 30),
                        itemCount: childrenList.length,
                        itemBuilder: (context, index) {
                          // individuelle Einträge abholen
                          DocumentSnapshot document = childrenList[index];
                          String docID = document.id;

                          // Eintrag von jedem Dokument abholen
                          Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                          String childText = data['child'];
                          String anmeldungText = data['anmeldung'];
                          String elternmail = data['eltern'];
                          String shownotification = data['shownotification'];

                          bool istAngemeldet = anmeldungText == "Abgemeldet";

                          var color =
                              istAngemeldet ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary;

                          // als List Tile wiedergeben
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChildOverviewPageKita(docID: docID,)),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(12),

                              ),
                              padding: const EdgeInsets.only(left: 10,),
                              margin: EdgeInsets.only(left: 20, right: 20, top: 10),





                              child: ListTile(
                                  title: Text(childText,
                                  ),
                                  subtitle: Text(anmeldungText,
                                    style: TextStyle(fontSize: 12,),
                                  ),
                                  // Button für Ändern
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                    if(shownotification == "1")
                                      IconButton(
                                        onPressed: () {
                                          notificationNullKind(docID);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ChatPage(
                                              receiverID: elternmail, childcode: docID,
                                            )),
                                          );
                                        },
                                        color: Theme.of(context).colorScheme.inversePrimary,
                                        icon: const Icon(Icons.mark_unread_chat_alt_outlined,),
                                      ),
                                      // ändern Button
                                      IconButton(
                                        onPressed: () => openChildBoxGroup(docID: docID),
                                        color: Theme.of(context).colorScheme.inversePrimary,
                                        icon: const Icon(Icons.settings),
                                      ),
                                      // Löschen button
                                      IconButton(
                                        onPressed: () => openChildBoxDelete(docID: docID),
                                        color: Theme.of(context).colorScheme.inversePrimary,
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  )

                              ),
                            ),
                          );
                        },
                      );
                    }
                    else {
                      return const Text("");
                    }
                  }
                    ),
              ),
            ],
          ),
        ],
      );
  }

  Widget optionb() {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: mediaQuery.size.width * 1,
              height: mediaQuery.size.height * 0.65,
              child: StreamBuilder<QuerySnapshot>(
                // Abfrage des definierten Streams in firestoreDatabaseChild, Stream = getChildrenStream
                  stream: firestoreDatabaseChild.getChildrenStream2(),
                  builder: (context, snapshot){
                    // wenn Daten vorhanden _> gib alle Daten aus
                    if (snapshot.hasData) {
                      List childrenList = snapshot.data!.docs;
                      //als Liste wiedergeben
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 30),
                        itemCount: childrenList.length,
                        itemBuilder: (context, index) {
                          // individuelle Einträge abholen
                          DocumentSnapshot document = childrenList[index];
                          String docID = document.id;

                          // Eintrag von jedem Dokument abholen
                          Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                          String childText = data['child'];
                          String anmeldungText = data['anmeldung'];

                          bool istAngemeldet = anmeldungText == "Abgemeldet";

                          var color =
                          istAngemeldet ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary;

                          // als List Tile wiedergeben
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChildOverviewPageKita(docID: docID,)),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(12),

                              ),
                              padding: const EdgeInsets.only(left: 10,),
                              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: ListTile(
                                  title: Text(childText,
                                  ),
                                  subtitle: Text(anmeldungText,
                                    style: TextStyle(fontSize: 12,),
                                  ),
                                  // Button für Ändern
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      // ändern Button
                                      IconButton(
                                        onPressed: () => openChildBoxGroup(docID: docID),
                                        color: Theme.of(context).colorScheme.inversePrimary,
                                        icon: const Icon(Icons.settings),
                                      ),
                                      // Löschen button
                                      IconButton(
                                        onPressed: () => openChildBoxDelete(docID: docID),
                                        color: Theme.of(context).colorScheme.inversePrimary,
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  )

                              ),
                            ),
                          );
                        },
                      );
                    }
                    else {
                      return const Text("");
                    }
                  }
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget optionc() {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: mediaQuery.size.width * 1,
              height: mediaQuery.size.height * 0.65,
              child: StreamBuilder<QuerySnapshot>(
                // Abfrage des definierten Streams in firestoreDatabaseChild, Stream = getChildrenStream
                  stream: firestoreDatabaseChild.getChildrenStream3(),
                  builder: (context, snapshot){
                    // wenn Daten vorhanden _> gib alle Daten aus
                    if (snapshot.hasData) {
                      List childrenList = snapshot.data!.docs;
                      //als Liste wiedergeben
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 30),
                        itemCount: childrenList.length,
                        itemBuilder: (context, index) {
                          // individuelle Einträge abholen
                          DocumentSnapshot document = childrenList[index];
                          String docID = document.id;

                          // Eintrag von jedem Dokument abholen
                          Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                          String childText = data['child'];
                          String anmeldungText = data['anmeldung'];

                          bool istAngemeldet = anmeldungText == "Abgemeldet";

                          var color =
                          istAngemeldet ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary;

                          // als List Tile wiedergeben
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChildOverviewPageKita(docID: docID,)),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(12),

                              ),
                              padding: const EdgeInsets.only(left: 10,),
                              margin: EdgeInsets.only(left: 20, right: 20, top: 10),





                              child: ListTile(
                                  title: Text(childText,
                                  ),
                                  subtitle: Text(anmeldungText,
                                    style: TextStyle(fontSize: 12,),
                                  ),
                                  // Button für Ändern
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      // ändern Button
                                      IconButton(
                                        onPressed: () => openChildBoxGroup(docID: docID),
                                        color: Theme.of(context).colorScheme.inversePrimary,
                                        icon: const Icon(Icons.settings),
                                      ),
                                      // Löschen button
                                      IconButton(
                                        onPressed: () => openChildBoxDelete(docID: docID),
                                        color: Theme.of(context).colorScheme.inversePrimary,
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  )

                              ),
                            ),
                          );
                        },
                      );
                    }
                    else {
                      return const Text("");
                    }
                  }
              ),
            ),
          ],
        ),
      ],
    );
  }
}