import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_list_tile_feed_kita.dart';
import 'package:socialmediaapp/database/firestore_feed.dart';
import 'package:intl/intl.dart';

import '../../components/notification_controller.dart';
import '../../helper/helper_functions.dart';


class FeedPageKita extends StatefulWidget {
  FeedPageKita({super.key});


  @override
  State<FeedPageKita> createState() => _FeedPageKitaState();
}

class _FeedPageKitaState extends State<FeedPageKita> {


  // Zugriff auf Firestore Datenbank
  final FirestoreDatabaseFeed database = FirestoreDatabaseFeed();


  // Text Controller
  final TextEditingController newPostControllerTitel = TextEditingController();
  final TextEditingController newPostControllerInhalt = TextEditingController();


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


  // Methode: Nachricht Posten Extern
  void postMessageExt(){
    // Nur Posten wenn etwas im Textfeld ist
    if (newPostControllerInhalt.text.isNotEmpty){
      String title = newPostControllerTitel.text;
      String content = newPostControllerInhalt.text;
      database.addPostExt(title, content);
    }
    // Eingabefeld nach Eingabe leeren
    newPostControllerInhalt.clear();
    newPostControllerTitel.clear();
  }


  // Methode: Nachricht Posten Intern
  void postMessageInt(){
    // Nur Posten wenn etwas im Textfeld ist
    if (newPostControllerInhalt.text.isNotEmpty){
      String title = newPostControllerTitel.text;
      String content = newPostControllerInhalt.text;
      database.addPostInt(title, content);
    }
    // Eingabefeld nach Eingabe leeren
    newPostControllerInhalt.clear();
    newPostControllerTitel.clear();
  }

bool externPost = false;


  void newPost() {
    final mediaQuery = MediaQuery.of(context);
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Neuer Post",
                style: TextStyle(color: Colors.black),
              ),
              content: Container(
                width: mediaQuery.size.width * 0.8,
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      controller: newPostControllerTitel,
                      decoration: InputDecoration(hintText: "Titel"),
                    ),
                    const SizedBox(height: 10,),
                    SingleChildScrollView(
                        child: Container(
                          height: mediaQuery.size.height * 0.25,
                          child: TextField(

                            keyboardType: TextInputType.multiline,
                            minLines: 5,
                            maxLines: 20,

                            controller: newPostControllerInhalt,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Inhalt...",

                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
              actions: [
                // cancel Button
                TextButton(
                  onPressed: () {
                    // Textfeld schliessen
                    Navigator.pop(context);
                    //Textfeld leeren
                    newPostControllerTitel.clear();
                    newPostControllerInhalt.clear();
                  },
                  child: Text("Abbrechen"),
                ),

                // save Button
                TextButton(
                  onPressed: () {
    if (newPostControllerInhalt.text.isNotEmpty  && newPostControllerTitel.text.isNotEmpty) {
    if (externPost) {
    // Raport hinzufügen
    postMessageExt();
    }
    else{
    postMessageInt();
    // Textfeld schliessen
    }
    Navigator.pop(context);
    //Textfeld leeren
    newPostControllerTitel.clear();
    newPostControllerInhalt.clear();
    }
    else {
      return displayMessageToUser("Bitte Titel und Inhalt eingeben", context);
    }
    },
                  child: Text("Speichern"),
                ),
              ],
            ),
      );
    }



  Widget showButtons () {
    return
      GestureDetector(
        onTap: () => setState(() => externPost = !externPost),
        child: Container(
          child: Row(
            children: [
              Text("Feed wechseln"),
              const SizedBox(width: 10),
              Icon(Icons.change_circle),
              const SizedBox(width: 15),
            ],
          ),
        ),
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
        ),
        actions: [
          showButtons(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: newPost,
        child: const Icon(
            Icons.message,
          color: Colors.white
        ),
      ),
        body:
        Container(
          child: Stack(
            children: [

              if (externPost)
                /// Externer Feed
              Column(
                children: [
                  const SizedBox(height: 30,),
                  Text(
                    "Externer Feed",
                    style: TextStyle(fontSize: 25,
                    color: Colors.black,
                        fontFamily: 'Goli',
                    ),
                  ),


                  const SizedBox(height: 20,),
                  StreamBuilder(
                      stream: database.getPostsStreamExt(),
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
                                        MyListTileFeedKita(
                                            title: title,
                                            content: content,
                                            subTitle: DateFormat('dd.MM.yyyy').format(timestamp.toDate()),
                                            postId: post.id,
                                            feed: "Feed_Extern"
                                      ),
                                      ]
                                    ),
                                  ],
                                );
                              }
                            )
                        );
                  }
                  ),
                ],
              ),

              /// Feed Intern
              if (externPost != true)
              Column(

                children: [
                  const SizedBox(height: 30,),
                  Text(
                    "Interner Feed",
                    style: TextStyle(fontSize: 25,
                      color: Colors.black,
                      fontFamily: 'Goli',
                    ),
                  ),


                  const SizedBox(height: 20,),


                  // Posts
                  StreamBuilder(
                      stream: database.getPostsStreamInt(),
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
                                            MyListTileFeedKita(
                                              title: title,
                                              content: content,
                                              subTitle: DateFormat('dd.MM.yyyy').format(timestamp.toDate()),
                                              postId: post.id,
                                                feed: "Feed_Intern"
                                            ),
                                          ]
                                      ),
                                    ],
                                  );
                                }
                            )
                        );
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}