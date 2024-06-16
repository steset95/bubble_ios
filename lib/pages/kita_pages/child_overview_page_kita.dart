import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/pages/chat_page.dart';
import 'package:socialmediaapp/pages/kita_pages/raport_page.dart';
import 'package:share_plus/share_plus.dart';

import 'einwilligungen_kind_page_kita.dart';
import 'images_page_kita.dart';
import 'infos_eltern_page_kita.dart';
import 'infos_kind_page_kita.dart';




class ChildOverviewPageKita extends StatefulWidget {
  final String docID;

  const ChildOverviewPageKita({
    super.key,
    required this.docID
  });

  @override
  State<ChildOverviewPageKita> createState() => _ChildOverviewPageKitaState();
}


class _ChildOverviewPageKitaState extends State<ChildOverviewPageKita> {





  /// Aktivierungsschlüssel
  void getDocumentID() {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(widget.docID)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        String documentID = document.id;
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(

            title: const Text(
              "Schlüssel",
            ),
            content: Row(
              children: [
                Text('$documentID'),
                IconButton(
                  onPressed: () async {
                    await Share.share('$documentID',
                    subject: 'Activationkey');
                    },
                    icon: Icon(Icons.share),
                ),

              ],
            ),
            actions: [
              // Cancel Button
              TextButton(
                child: const Text("Schliessen",
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      } else {
        print('Das Dokument existiert nicht.');
      }
    }).catchError((error) {
      print('Fehler beim Abrufen des Dokuments: $error');
    });
  }



  @override
  Widget build(BuildContext context) {
    String currentDate = DateTime.now().toString(); // Aktuelles Datum als String
    String formattedDate = currentDate.substring(0, 10); // Nur das Datum extrahieren
    final mediaQuery = MediaQuery.of(context);
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
            title: Text("Übersicht",
              style: TextStyle(color:Colors.black),
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RaportPage(docID: widget.docID,)),
              );
            },
            child: const Icon(Icons.add),
          ),


          body: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: mediaQuery.size.height * 0.08,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child:  StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Kinder")
                            .doc(widget.docID)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(

                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 25, color: Colors.black,),
                                    snapshot.data!['child']),
                              ],
                            );
                          };
                          return const Text("");
                        },
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Kinder")
                          .doc(widget.docID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final abholzeit = snapshot.data!['abholzeit'];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Abholzeit: $abholzeit',
                                style: TextStyle(color:Colors.black),

                              ),
                            ],
                          );
                        };
                        return const Text("");
                      },
                    ),
                  ],
                ),
              ),






              const SizedBox(height: 10),


              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: getDocumentID,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 100,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Aktivierung"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                ImagesPageKita(
                                    docID: widget.docID)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 100,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Bilder"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      flex: 1,
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Kinder")
                              .doc(widget.docID)
                              .snapshots(),
                          builder: (context, snapshot)
                          {
                            // ladekreis
                            if (snapshot.hasData) {
                              // Entsprechende Daten extrahieren
                              final userData = snapshot.data?.data() as Map<String, dynamic>;


                              final elternmail = userData["eltern"];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChatPage(
                                      receiverID: elternmail,
                                    )),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  height: 100,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Chat"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Text("");
                          }
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                InfosKindPageKita(
                                    docID: widget.docID)),
                          );
                        },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Infos"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                EinwilligungenKindPageKita(
                                    docID: widget.docID)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 100,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Erlaubnis"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                InfosElternPageKita(
                                    docID: widget.docID)),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        height: 100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Eltern"),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: mediaQuery.size.height * 0.45,
                    width: mediaQuery.size.width * 1,
                    child: StreamBuilder<QuerySnapshot>(

                    stream:  FirebaseFirestore.instance
                        .collection("Kinder")
                        .doc(widget.docID)
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
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  padding: EdgeInsets.all(5),

                                  width: mediaQuery.size.width * 0.9,
                                  color: Colors.pinkAccent.withOpacity(0.3),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              raport['Uhrzeit'],
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                              raport['RaportTitle']),
                                        ],
                                      ),
                                    const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Container(
                                              width: mediaQuery.size.width * 0.85,
                                              child: Text(
                                                  textAlign: TextAlign.left,
                                                  raport['RaportText'])),
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
                          padding: EdgeInsets.only(bottom: 30),
                          children: raportWidgets,
                        );
                    }
                    ),
                  ),
                ],
              ),
                          ],
          ),
    ),
    );
  }




}
