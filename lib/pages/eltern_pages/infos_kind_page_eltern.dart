
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

import '../../components/my_profile_data_switch.dart';
import '../../components/notification_controller.dart';
import '../../database/firestore_child.dart';
import '../../helper/helper_functions.dart';
import 'addkind_page_eltern.dart';







class InfosKindPageEltern extends StatefulWidget {


  InfosKindPageEltern({
    super.key,

  });



  @override
  State<InfosKindPageEltern> createState() => _InfosKindPageElternState();
}

class _InfosKindPageElternState extends State<InfosKindPageEltern> {


  final currentUser = FirebaseAuth.instance.currentUser;
  final FirestoreDatabaseChild firestoreDatabaseChild = FirestoreDatabaseChild();


  final kinderCollection = FirebaseFirestore
      .instance
      .collection("Kinder"
  );


  var field = 'erlaubt';



  var optionsGeschlecht = [
    'weiblich',
    'männlich',
    'keine Angabe'
  ];

  var _currentItemSelectedGeschlecht = 'keine Angabe';
  var fieldGeschlecht = 'keine Angabe';




  bool showProgress = false;
  bool visible = false;



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






  void openChildBoxGeschlecht({String? childcode, String? datensatz}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Text Eingabe
        content: DropdownButtonFormField<String>(
          isDense: true,
          isExpanded: false,

          items: optionsGeschlecht.map((String dropDownStringItem) {
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
          value: _currentItemSelectedGeschlecht, onChanged: (newValueSelected) {
          setState(() {
            _currentItemSelectedGeschlecht = newValueSelected!;
            field = newValueSelected;
          });
        },
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

              // Button wird für hinzufügen(unten) und anpassen (neben Kind) genutzt, daher wird zuerst geprüft ob
              // es um einen bestehenden oder neuen Datensatz geht
              if (childcode != null) {
                // Child Datensatz hinzufügen
                // Verweis auf "firestoreDatabaseChild" Widget in "firestore_child.dart" File
                // auf die Funktion "addChild" welche dort angelegt ist
                // TextController wurde oben definiert und fragt den Text im Textfeld ab
                firestoreDatabaseChild.updateChildEinwilligungen(childcode, datensatz!, _currentItemSelectedGeschlecht,);
              }
              //Box schliessen
              Navigator.pop(context);
            },
            child: Text("Speichern"),
          )
        ],
      ),
    );
  }







// Bearbeitungsfeld
  void editFieldInfos(String title, String field, String childcode, String value ) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(
              "$title",
              //"Edit $field",
            ),
            content: TextFormField(
              initialValue: value,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 20,
              autofocus: true,

              onChanged: (value) {
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


    if (newValue.trim().length > 0) {

      await kinderCollection.doc(childcode).update({field: newValue});
    }
  }

  Widget showData () {
      return SingleChildScrollView(
          child:
          StreamBuilder(
          stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final userData = snapshot.data?.data() as Map<String, dynamic>;
        final childcode = userData["childcode"];
        if (snapshot.hasData && childcode != "") {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Kinder")
                .doc(childcode)
                .snapshots(),
            builder: (context, snapshot) {
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
                        text: userData["child"],
                        sectionName: "Name",
                        onPressed: () => editFieldInfos("Name", "child", childcode, userData["child"]),
                      ),

                      ProfileData(
                        text: userData["geschlecht"],
                        sectionName: "Geschlecht",
                        onPressed: () =>
                        openChildBoxGeschlecht(
                        childcode: childcode,
                        datensatz: 'geschlecht'),
                      ),



                      ProfileData(
                        text: userData["geburtstag"],
                        sectionName: "Geburtstag",
                        onPressed: () => editFieldInfos("Geburtstag", "geburtstag", childcode, userData["geburtstag"]),
                      ),

                      ProfileData(
                        text: userData["personen"],
                        sectionName: "Zur Abholung berechtigte Personen",
                        onPressed: () => editFieldInfos("Berechtigte Personen", "personen", childcode, userData["personen"]),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Text("Gesundheitsangaben",
                        style: TextStyle(fontSize: 20),
                      ),


                      ProfileData(
                        text: userData["alergien"],
                        sectionName: "Alergien",
                        onPressed: () => editFieldInfos("Alergien", "alergien", childcode, userData["alergien"]),
                      ),

                      ProfileData(
                        text: userData["krankheiten"],
                        sectionName: "Krankheiten",
                        onPressed: () => editFieldInfos("Krankheiten", "krankheiten", childcode, userData["krankheiten"]),
                      ),

                      ProfileData(
                        text: userData["medikamente"],
                        sectionName: "Medikamente",
                        onPressed: () => editFieldInfos("Medikamente", "medikamente", childcode, userData["medikamente"]),
                      ),

                      ProfileData(
                        text: userData["impfungen"],
                        sectionName: "Impfungen",
                        onPressed: () => editFieldInfos("Impfungen", "impfungen", childcode, userData["impfungen"]),
                      ),

                      ProfileData(
                        text: userData["kinderarzt"],
                        sectionName: "Kinderarzt",
                        onPressed: () => editFieldInfos("Kinderarzt", "kinderarzt", childcode, userData["kinderarzt"]),
                      ),

                      ProfileData(
                        text: userData["krankenkasse"],
                        sectionName: "Krankenkasse",
                        onPressed: () => editFieldInfos("Krankenkasse", "krankenkasse", childcode, userData["krankenkasse"]),
                      ),

                      ProfileData(
                        text: userData["bemerkungen"],
                        sectionName: "Bemerkungen",
                        onPressed: () => editFieldInfos("Bemerkungen", "bemerkungen", childcode, userData["bemerkungen"]),
                      ),


                      SizedBox(
                        height: 30,
                      ),
                      Text("Einwilligungen Kind",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ProfileDataSwitch(
                        text: userData["fotosSocialMedia"],
                        sectionName: "Fotos für SocialMedia",
                        field: "fotosSocialMedia",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["fotosApp"],
                        sectionName: "Fotos für App",
                        field: "fotosApp",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["nagellack"],
                        sectionName: "Nagellack auftragen",
                        field: "nagellack",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["schminken"],
                        sectionName: "Schminken",
                        field: "schminken",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["fieber"],
                        sectionName: "Rektales Fiebermessen",
                        field: "fieber",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["sonnencreme"],
                        sectionName: "Sonnencreme auftragen",
                        field: "sonnencreme",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["fremdkoerper"],
                        sectionName: "Fremdkörper entfernen (bspw. Zecken)",
                        field: "fremdkoerper",
                        childcode: childcode,
                      ),

                      ProfileDataSwitch(
                        text: userData["homoeopathie"],
                        sectionName: "Homöopathie",
                        field: "homoeopathie",
                        childcode: childcode,
                      ),


                    ],
                  );
                // Fehlermeldung wenn nichts vorhanden ist
              } else {
                return const Text("Keine Daten vorhanden");
              }
            },

          );

    }
    }
      if (snapshot.connectionState != ConnectionState.waiting)

        return Column(
        mainAxisAlignment: MainAxisAlignment.center,
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

          )
      );

  }




  Widget showButtons () {
    return
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                AddKindPageEltern(),
            ),
          );
        },
        child: Container(
          child: Row(
            children: [
              Text("Kind wechseln"),
              const SizedBox(width: 10),
              Icon(Icons.child_care),
              const SizedBox(width: 15),
            ],
          ),
        ),
      );
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
          title: Text("Infos Kind",
            style: TextStyle(color:Colors.black),
          ),
          actions: [
            showButtons(),
          ],
        ),
        body: showData(),
      )
            );
    }
}







