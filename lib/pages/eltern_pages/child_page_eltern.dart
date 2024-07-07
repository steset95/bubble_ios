import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/database/firestore_child.dart';
import 'package:socialmediaapp/pages/eltern_pages/images_page_eltern.dart';
import '../../components/my_progressindicator.dart';
import '../../components/notification_controller.dart';
import '../../old/my_image_upload_button_profile.dart';
import '../../components/my_image_viewer_profile.dart';
import '../../helper/helper_functions.dart';
import '../chat_page.dart';
import '../../old/einwilligungen_kind_page_eltern.dart';
import 'addkind_page_eltern.dart';
import 'infos_kind_page_eltern.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ChildPageEltern extends StatefulWidget {

  ChildPageEltern({super.key});

  @override
  State<ChildPageEltern> createState() => _ChildPageElternState();
}



class _ChildPageElternState extends State<ChildPageEltern> {

  // Verweis auf FirestoreDatabaseChild

  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();

 // Text Controller für Abfrage des Inhalts im Textfeld

  final TextEditingController textController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

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


 var optionsAbholzeit = [
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '12:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
  ];

  var _currentItemSelectedAbholzeit = '17:00';
  var abholzeit = '';


  bool showProgress = false;
  bool visible = false;

  final _raportTextController = TextEditingController();

  void addRaport(String field, String value, String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .update({
      field: value,
      'timestamp': Timestamp.now(),
    });
  }


  void showRaportDialogAbsenz(String childcode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Absenz bis:",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content: TextField (
          //maxLength: 5,
          autofocus: true,
          //keyboardType: TextInputType.number,
          controller: _raportTextController,
          decoration: InputDecoration(hintText: "TT.MM"),
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
              final value = _raportTextController.text;
              // Raport hinzufügen
              addRaport("anmeldung", 'Absenz bis $value', childcode);
              // Textfeld schliessen
              Navigator.pop(context);
              return displayMessageToUser("Absenz wurde eingetragen.", context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Speichern"),
          ),
        ],
      ),
    );
  }



  // Raport hinzufügen bzw. Allgemeiner Firebase Connect
  void addRaportAbholzeit(String abholzeit, String childcode) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    // in Firestore speichern und "Raports" unter "Kinder" erstellen
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .collection(formattedDate)
        .doc("abholzeit")
        .set({
      "Abholzeit" : abholzeit,
    });
  }



  void openChildBoxAbholzeit({String? childcode}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Abholzeit",
          style: TextStyle(color: Colors.black,
            fontSize: 20,
          ),
        ),
        content: DropdownButtonFormField<String>(
          isDense: true,
          isExpanded: false,

          items: optionsAbholzeit.map((String dropDownStringItem) {
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
          value: _currentItemSelectedAbholzeit, onChanged: (newValueSelected) {
          setState(() {
            _currentItemSelectedAbholzeit = newValueSelected!;
            abholzeit = newValueSelected;
          });
        },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Textfeld schliessen
              Navigator.pop(context);
              //Textfeld leeren
              _raportTextController.clear();
            },
            child: Text("Abbrechen"),
          ),
          // Speicher Button
          TextButton(
            onPressed: () {

              // Button wird für hinzufügen(unten) und anpassen (neben Kind) genutzt, daher wird zuerst geprüft ob
              // es um einen bestehenden oder neuen Datensatz geht
              if (childcode != null) {
                // Child Datensatz hinzufügen
                // Verweis auf "firestoreDatabaseChild" Widget in "firestore_child.dart" File
                // auf die Funktion "addChild" welche dort angelegt ist
                // TextController wurde oben definiert und fragt den Text im Textfeld ab
                addRaport("abholzeit", _currentItemSelectedAbholzeit, childcode);
              }
              //Box schliessen
              Navigator.pop(context);
              return displayMessageToUser("Abholzeit wurde eingetragen.", context);
            },
            child: Text("Speichern"),
          )
        ],
      ),
    );
  }



  int _counter = 0;

  void _incrementCounterMinus() {
    setState(() {
      _counter++;
    });
  }

  void _incrementCounterPlus() {
    setState(() {
      _counter--;
    });
  }


  Future<List<String>> getImagePath(String childcode, ) async {
    String currentDate = DateTime.now().subtract(Duration(days:_counter)).toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    ListResult result =
    await FirebaseStorage.instance.ref('/images/$formattedDate/$childcode').listAll();
    return await Future.wait(
      result.items.map((e) async => await e.getDownloadURL()),
    );
  }

  Widget buildGallery(String childcode) {
    String currentDate = DateTime.now().subtract(Duration(days:_counter)).toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    final mediaQuery = MediaQuery.of(context);
    return FutureBuilder(
      future: getImagePath(childcode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Text("");
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: Container(
           height: mediaQuery.size.height * 0.075,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              shrinkWrap: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 1.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImagesPageEltern(
                      childcode: childcode, date: formattedDate,
                    )),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: snapshot.data![index],
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => ProgressWithIcon(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        );
      },
    );
  }







  /// Kita Mail in User hinzufügen

  void getKitaEmail(String childID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childID)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        String kita = document["kita"];
        FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .update({
          "kitamail" : kita,
      });
            }
    });
  }



  Widget showButtons () {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser?.email)
            .snapshots(),
      builder: (context, snapshot) {
    if (snapshot.hasData) {
      final userData = snapshot.data?.data() as Map<String, dynamic>;
      final childcode = userData["childcode"];
      if (snapshot.hasData && childcode != "") {
        getKitaEmail(userData["childcode"]);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [


            /// Abholzeit
            IconButton(
              onPressed: () => openChildBoxAbholzeit(childcode: childcode),
              icon: const Icon(Icons.watch_later_outlined,
              ),
            ),
            const SizedBox(width: 15),

            /// Absenzmeldung

            IconButton(
              onPressed: () => showRaportDialogAbsenz(childcode),
              icon: const Icon(Icons.beach_access_outlined,
              ),
            ),
            const SizedBox(width: 20),
                      ],
        );
      }
    }
   return Text("");
      }
    );


  }



/// Start Widget


  @override
  Widget build(BuildContext context)  {
    final String currentDate = DateTime.now().subtract(Duration(days:_counter)).toString(); // Aktuelles Datum als String
    final String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    final mediaQuery = MediaQuery.of(context);
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
          actions: [
            showButtons(),
          ],
        ),

        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
          .doc(currentUser?.email)
          .snapshots(),
              builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data?.data() as Map<String, dynamic>;
          final childcode = userData["childcode"];
          if (snapshot.hasData && childcode != "") {
            getKitaEmail(userData["childcode"]);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: _incrementCounterMinus,
                      child: Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(Icons.arrow_back_ios_rounded,
                          //color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    ),
                    /// Profilbild
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ImageViewerProfile(childcode: childcode),
                            const SizedBox(height: 10),

                            Text(formattedDate,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Goli',),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _incrementCounterPlus,
                      child: Container(
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(Icons.arrow_forward_ios_rounded,
                          //color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: mediaQuery.size.height * 0.50,
                          width: mediaQuery.size.width * 1,
                          child: StreamBuilder<QuerySnapshot>(
                              stream:  FirebaseFirestore.instance
                                  .collection("Kinder")
                                  .doc(childcode)
                                  .collection(formattedDate)
                                  .orderBy('TimeStamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                List<Row> raportWidgets = [];
                                if (snapshot.hasData) {
                                  final raports = snapshot.data?.docs.reversed.toList();
                                  for (var raport in raports!) {
                                    final raportWidget = Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                          padding: EdgeInsets.only(top: 6, bottom: 6, left: 15,),
                                          decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.secondary,
                                          borderRadius: BorderRadius.circular(10),
                                          ),
                                            width: mediaQuery.size.width * 0.9,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        raport['Uhrzeit'],
                                                        style: TextStyle(fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                        )
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                        raport['RaportTitle'],
                                                      style: TextStyle(fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: mediaQuery.size.width * 0.80,
                                                        child: Text(
                                                            textAlign: TextAlign.left,
                                                            raport['RaportText'],
                                                          style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                        ),
                                      ],
                                    );
                                    raportWidgets.add(raportWidget);
                                    Text(raport['RaportText']);
                                  }
                                }

                                return
                                  ListView(
                                    children: raportWidgets,
                                  );
                              }
                          ),
                        ),
                                        ],
                    ),
                  ],
                ),

                /// Galerie

                const SizedBox(height: 10),

                buildGallery(childcode),


                /// Datum wählen
              ],
            );
          }
        }
        if (snapshot.connectionState != ConnectionState.waiting)

          return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 71),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text("Bitte Kind hinzufügen",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.add_reaction_outlined,
                        size: 60,
                      ), onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            AddKindPageEltern(),
                        ),
                      );
                    },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
                else
                return
                Text("");
              }
        ),
        ),
    );

                }
            }
