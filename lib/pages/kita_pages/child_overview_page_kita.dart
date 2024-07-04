import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/pages/chat_page.dart';
import 'package:socialmediaapp/pages/kita_pages/raport_page.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/notification_controller.dart';
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

  void notificationNullKind(String docID) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(docID)
        .update({"shownotification": "0"});
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
                height: 1.0,
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
                                    style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold,),
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
                                style: TextStyle(color:Colors.black,
                                    fontFamily: 'Goli',
                                ),
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

                              const Icon(Icons.check),
                              const SizedBox(height: 5),
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
                              const Icon(Icons.camera_alt),
                              const SizedBox(height: 5),
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
                            if (snapshot.connectionState == ConnectionState.waiting)
                              return Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 100,
                                child: const Column(

                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.chat),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Chat"),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            // ladekreis
                            if (snapshot.hasData) {
                              // Entsprechende Daten extrahieren
                              final userData = snapshot.data?.data() as Map<String, dynamic>;


                              final elternmail = userData["eltern"];
                              String shownotification = userData['shownotification'];
                              if(shownotification == "0") {
                                return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChatPage(
                                      receiverID: elternmail, childcode: widget.docID,
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
                                      const Icon(Icons.chat),
                                      const SizedBox(height: 5),
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
                              if(shownotification == "1") {
                                return GestureDetector(
                                  onTap: () {
                                    notificationNullKind(widget.docID);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ChatPage(
                                        receiverID: elternmail, childcode: widget.docID,
                                      )),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    height: 100,
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.mark_unread_chat_alt_outlined,),
                                        const SizedBox(height: 5),
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
                            const Icon(Icons.library_books_outlined),
                            const SizedBox(height: 5),
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
                              const Icon(Icons.check),
                              const SizedBox(height: 5),
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
                            const Icon(Icons.family_restroom),
                            const SizedBox(height: 5),
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
                                  style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                              raport['RaportTitle'],
                                              style: TextStyle(fontWeight: FontWeight.bold)
                                              ),
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