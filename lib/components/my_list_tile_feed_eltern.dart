import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class MyListTileFeedEltern extends StatefulWidget {
  final String title;
  final String subTitle;
  final String postId;
  final String content;


  const MyListTileFeedEltern({
    super.key,
    required this.title,
    required this.subTitle,
    required this.postId,
    required this.content,


  });

  @override
  State<MyListTileFeedEltern> createState() => _MyListTileFeedElternState();
}

class _MyListTileFeedElternState extends State<MyListTileFeedEltern> {

  final CollectionReference users = FirebaseFirestore.instance.collection("Users");
  final CollectionReference posts = FirebaseFirestore.instance.collection("Feed");

  User? user = FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(
          left: 10, right: 10, bottom: 10
      ),
      child: Container(

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            //border: Border.all(color: Colors.black),
          color: Theme.of(context).colorScheme.secondary,

          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child:
        ListTile(
          title: Column(
            children: [
              Text(
                style: TextStyle(fontSize: 18,),
                widget.title,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: mediaQuery.size.width * 0.80,
                    child: Text(
                      style: TextStyle(fontSize: 12,
                      ),
                      widget.content,
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(widget.subTitle,
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
