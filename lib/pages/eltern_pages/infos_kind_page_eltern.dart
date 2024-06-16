
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay/pay.dart';
import 'package:socialmediaapp/components/my_profile_data.dart';

import '../../database/firestore_child.dart';
import '../../helper/helper_functions.dart';







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


  var options = [
    'erlaubt',
    'nicht erlaubt',
  ];

  var _currentItemSelected = 'erlaubt';
  var field = 'erlaubt';

  bool showProgress = false;
  bool visible = false;


// Bearbeitungsfeld
  void openChildBoxEinwilligungen({String? childcode, String? datensatz}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Text Eingabe
        content: DropdownButtonFormField<String>(
          isDense: true,
          isExpanded: false,

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
            field = newValueSelected;
          });
        },
        ),
        actions: [
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
                firestoreDatabaseChild.updateChildEinwilligungen(childcode, datensatz!, _currentItemSelected,);
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
  void editFieldInfos(String title, String field, String childcode, ) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(
              "$title",
              //"Edit $field",
            ),
            content: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 20,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Bearbeiten...",
              ),
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
                        onPressed: () => editFieldInfos("Name", "child", childcode),
                      ),

                      ProfileData(
                        text: userData["geschlecht"],
                        sectionName: "Geschlecht",
                        onPressed: () => editFieldInfos("Geschlecht", "geschlecht", childcode),
                      ),




                      onPressed: () =>
                          openChildBoxEinwilligungen(
                              childcode: childcode,
                              datensatz: 'sonnencreme'),


                      ProfileData(
                        text: userData["geburtstag"],
                        sectionName: "Geburtstag",
                        onPressed: () => editFieldInfos("Geburtstag", "geburtstag", childcode),
                      ),

                      ProfileData(
                        text: userData["personen"],
                        sectionName: "Zur Abholung berechtigte Personen",
                        onPressed: () => editFieldInfos("Berechtigte Personen", "personen", childcode),
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
                        onPressed: () => editFieldInfos("Alergien", "alergien", childcode),
                      ),

                      ProfileData(
                        text: userData["krankheiten"],
                        sectionName: "Krankheiten",
                        onPressed: () => editFieldInfos("Krankheiten", "krankheiten", childcode),
                      ),

                      ProfileData(
                        text: userData["medikamente"],
                        sectionName: "Medikamente",
                        onPressed: () => editFieldInfos("Medikamente", "medikamente", childcode),
                      ),

                      ProfileData(
                        text: userData["impfungen"],
                        sectionName: "Impfungen",
                        onPressed: () => editFieldInfos("Impfungen", "impfungen", childcode),
                      ),

                      ProfileData(
                        text: userData["kinderarzt"],
                        sectionName: "Kinderarzt",
                        onPressed: () => editFieldInfos("Kinderarzt", "kinderarzt", childcode),
                      ),

                      ProfileData(
                        text: userData["krankenkasse"],
                        sectionName: "Krankenkasse",
                        onPressed: () => editFieldInfos("Krankenkasse", "krankenkasse", childcode),
                      ),

                      ProfileData(
                        text: userData["bemerkungen"],
                        sectionName: "Bemerkungen",
                        onPressed: () => editFieldInfos("Bemerkungen", "bemerkungen", childcode),
                      ),


                      SizedBox(
                        height: 30,
                      ),
                      Text("Einwilligungen Kind",
                        style: TextStyle(fontSize: 20),
                      ),

                      ProfileData(
                        text: userData["fotosSocialMedia"],
                        sectionName: "Fotos für SocialMedia",
                        onPressed: () =>
                            openChildBoxEinwilligungen(
                                childcode: childcode,
                                datensatz: 'fotosSocialMedia'),
                      ),

                      ProfileData(
                        text: userData["fotosApp"],
                        sectionName: "Fotos für App",
                        onPressed: () =>
                            openChildBoxEinwilligungen(
                                childcode: childcode,
                                datensatz: 'fotosApp'),
                      ),

                      ProfileData(
                        text: userData["nagellack"],
                        sectionName: "Nagellack auftragen",
                        onPressed: () =>
                            openChildBoxEinwilligungen(
                                childcode: childcode,
                                datensatz: 'nagellack'),
                      ),

                      ProfileData(
                        text: userData["schminken"],
                        sectionName: "Schminken",
                        onPressed: () =>
                            openChildBoxEinwilligungen(
                                childcode: childcode,
                                datensatz: 'schminken'),
                      ),

                      ProfileData(
                        text: userData["fieber"],
                        sectionName: "Rektales Fiebermessen",
                        onPressed: () =>
                            openChildBoxEinwilligungen(
                                childcode: childcode,
                                datensatz: 'fieber'),
                      ),

                      ProfileData(
                        text: userData["sonnencreme"],
                        sectionName: "Sonnencreme auftragen",
                        onPressed: () =>
                            openChildBoxEinwilligungen(
                                childcode: childcode,
                                datensatz: 'sonnencreme'),
                      ),

                      ProfileData(
                        text: userData["fremdkoerper"],
                        sectionName: "Fremdkörper entfernen (bspw. Zecken)",
                        onPressed: () =>
                            openChildBoxEinwilligungen(
                                childcode: childcode,
                                datensatz: 'fremdkoerper'),
                      ),

                      ProfileData(
                        text: userData["homoeopathie"],
                        sectionName: "Homöopathie",
                        onPressed: () =>
                            openChildBoxEinwilligungen(
                                childcode: childcode,
                                datensatz: 'homoeopathie'),
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
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 71),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Bitte Kind hinzufügen",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ],
      );
    }

          )
      );

  }

  /// Kind hinzufügen Altert Dialog

  final TextEditingController textController = TextEditingController();

  /// Code hinzufügen

  void addChildCode(String childcode) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .update({
      "childcode" : childcode,
    });
  }

  /// Eltern Mail in Kind hinzufügen

  void addElternMail(String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .update({
      "eltern" : currentUser?.email,
    });
  }



  void openChildBoxCode({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Text Eingabe
        content: TextField(
          //Abfrage Inhalt Textfeld - oben definiert
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Aktivierungsschlüssel...",
          ),
        ),
        actions: [

          // Speicher Button
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("Kinder")
                  .doc(textController.text)
                  .get()
                  .then((DocumentSnapshot document) {
                if (document.exists) {
                  addChildCode(textController.text);
                  addElternMail(textController.text);
                  // Textfeld leeren nach Eingabe
                  textController.clear();
                  //Box schliessen
                  Navigator.pop(context);
                }
                else {
                  return displayMessageToUser("Aktivierungscode ist unglütig.", context);
                }
              }
              );
            }, child: Text("Kind Hinzufügen"),
          ),
        ],
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
              height: 2.0,
            ),
          ),
          title: Text("Infos Kind",
            style: TextStyle(color:Colors.black),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: openChildBoxCode,
          child: const Icon(Icons.child_care),
        ),
        body: showData(),
      )
            );
    }
}







