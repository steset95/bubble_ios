
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/database/firestore_feed.dart';
import 'package:intl/intl.dart';
import '../../components/my_list_tile_feed_eltern.dart';
import '../../components/my_profile_data_read_only.dart';
import '../../components/notification_controller.dart';
import '../chat_page.dart';
import 'addkind_page_eltern.dart';
import 'infos_kita_page_eltern.dart';







class FeedPageEltern extends StatefulWidget {
  FeedPageEltern({super.key});



  @override
  State<FeedPageEltern> createState() => _FeedPageElternState();
}

class _FeedPageElternState extends State<FeedPageEltern> {


  // Zugriff auf Firestore Datenbank
  final FirestoreDatabaseFeed database = FirestoreDatabaseFeed();
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


  void getKitaInfos() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get()
        .then((DocumentSnapshot document) {
      final kitamail = document["kitamail"];
      if (document["kitamail"] != "") {
        return showDialog(

          context: context,
          builder: (context) =>
              AlertDialog(
                title: const Text(
                  "Kita Infos",
                  textAlign: TextAlign.center,
                ),
                content: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(kitamail)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final username = snapshot.data!['username'];
                      final adress = snapshot.data!['adress'];
                      final adress2 = snapshot.data!['adress2'];
                      final tel = snapshot.data!['tel'];

                      return
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              ProfileDataReadOnly(
                                text: username,
                                sectionName: "Name",
                              ),
                              ProfileDataReadOnly(
                                text: adress,
                                sectionName: "Adresse",
                              ),
                              ProfileDataReadOnly(
                                text: adress2,
                                sectionName: "Ort",
                              ),
                              ProfileDataReadOnly(
                                text: tel,
                                sectionName: "Telefonnummer",
                              ),
                            ],
                          ),
                        );
                    };
                    return const Text("");
                  },
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
        return Text("Noch kein Kind registriert...");
      }
    }).catchError((error) {
      print('Fehler beim Abrufen des Dokuments: $error');
    });
  }



  void notificationNullEltern() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .update({"shownotification": "0"});


  }



  Widget showButtons() {
    return
      StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data?.data() as Map<String, dynamic>;
              final kitamail = userData["kitamail"];
              final childcode = userData["childcode"];
              final shownotification = userData["shownotification"];
              if (kitamail != "") {
                return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            InfosKitaPageEltern(
                              kitamail: kitamail,
                            )),
                      );
                    },
                    icon: const Icon(Icons.info,
                    ),
                  ),
                  const SizedBox(width: 15),
                  if (shownotification == "0")
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ChatPage(
                              receiverID: kitamail, childcode: childcode,
                            )),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble,
                    ),
                  ),
                  if (shownotification == "1")
                    IconButton(
                      onPressed: () {

                        notificationNullEltern();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              ChatPage(
                                receiverID: kitamail, childcode: childcode,
                              )),
                        );
                      },
                      icon: const Icon(Icons.mark_unread_chat_alt_outlined,
                        color: Colors.orange,
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
        title: Text("Kita",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          showButtons(),
        ],
      ),
      body:
      Stack(
        children: [
            Column(
              children: [

                const SizedBox(height: 30,),

                ///Kitamail abholen

        StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
        .doc(currentUser?.email)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
    final userData = snapshot.data?.data() as Map<String, dynamic>;
    if (userData["kitamail"] == "")
    {

      return Text("");
    }

    else {

    final kitamail = userData["kitamail"];

    return

    ///Kita name ausgeben

    StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection("Users")
        .doc(kitamail)
        .snapshots(),
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    final username = snapshot.data!['username'];


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        Text(
            username,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
            ),
              ],
    );
    };
    return const Text("");
    },
    );
    }
         }
          return Text("");
            }
            ),
                // Textfeld für Benutzereingabe


                const SizedBox(height: 20),

                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUser?.email)
                        .snapshots(),
                    builder: (context, snapshot)
                    {
                      if (snapshot.hasData) {
                        final userData = snapshot.data?.data() as Map<String, dynamic>;

                        /// Feed nach KitaMail anzeigen und prüfen ob leer

                        if (userData["kitamail"] != "") {
                          return StreamBuilder(
                              stream: database.getPostsStreamEltern(userData["kitamail"]),
                              builder: (context, snapshot){
                                // Ladekreis anzeigen
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                // get all Posts
                                final posts = snapshot.data!.docs;

                                // no Data?
                                if (snapshot.data == null || posts.isEmpty){
                                  return const Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(25),
                                        child: Text("Noch keine Einträge vorhanden...")
                                    ),
                                  );
                                }
                                // Als Liste zurückgeben
                                return Expanded(
                                    child: ListView.builder(
                                        itemCount: posts.length,
                                        itemBuilder: (context, index) {

                                          // Individuelle Posts abholen
                                          final post = posts[index];

                                          // Daten von jedem Post abholen
                                          String title = post['titel'];
                                          String content = post['inhalt'];
                                          Timestamp timestamp = post['TimeStamp'];

                                          // Liste als Tile wiedergeben
                                          return Column(
                                            children: [
                                              Stack(
                                                  children: [
                                                    MyListTileFeedEltern(
                                                      content: content,
                                                      title: title,
                                                      subTitle: DateFormat('dd.MM.yyyy').format(timestamp.toDate()),
                                                      postId: post.id,
                                                    ),
                                                  ]
                                              ),
                                            ],
                                          );
                                        }
                                    )
                                );
                              }
                          );
                        }
                        else Text("Noch kein Kind registriert...");
                      }

                      if (snapshot.connectionState != ConnectionState.waiting)

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(25),
                              child: Text("Noch keine Einträge vorhanden..."

                              )
                          ),
                        ],
                      );
                      else
                        return
                          Text("");
                    }
                ),

              ],
            ),
        ],
      ),
    );
  }
}