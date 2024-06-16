import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/my_message.dart';


class MyChat{

final currentUser = FirebaseAuth.instance.currentUser;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

Future<void> sendMessage(String receiverEmail, message) async {
  //get current user Info
  final String currentUserID = _firebaseAuth.currentUser!.email!;
  final String currentUserEmail = _firebaseAuth.currentUser!.email!;
  final Timestamp timestamp = Timestamp.now();


  // create a new message
  Message newMessage = Message(
    senderID: currentUserEmail,
    senderEmail: currentUserEmail,
    receiverID: receiverEmail,
    message: message,
    timestamp: timestamp,

  );

// construct room ID for the two users (sorted to ensure uniqueness)
  List<String> ids = [currentUserID, receiverEmail];
  ids.sort(); // sort the ids (this ensure the chatroomID is the same for any 2 people)
  String chatRoomID = ids.join('_');

  //add new message to database
  await _firestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .add(newMessage.toMap());
}

  //get messages
Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
  // construct a chatroom ID for the two users
  List <String> ids = [userID, otherUserID];
  ids.sort();
  String chatRoomID = ids.join('_');

  return _firestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
}


User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}



}


