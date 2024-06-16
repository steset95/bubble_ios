import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import '../components/my_chatbubble.dart';
import '../database/firebase_chat.dart';


class ChatPage extends StatelessWidget {
  //final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    //required this.receiverEmail,
    required this.receiverID,
  });

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final MyChat _chatService = MyChat();


  // send message
  void sendMessage() async {
    //if there is something inside the Textfield
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);

    _messageController.clear();
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 2.0,
          ),
        ),
        title: Text("Chat",
          style: TextStyle(color:Colors.black),
        ),
      ),
            body: Column(
             children: [
               Expanded(
                child: _buildMessageList(),
               ),
               const SizedBox(height: 10,),
               _buildUserInput(),
             ],
            ),
    );
  }


Widget _buildMessageList() {
  String? senderID = _chatService.getCurrentUser()!.email;
  return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot)
  {
    if (snapshot.hasError) {
      return const Text("error");
    }

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text("loading");
    }
    return ListView(
      reverse: true,
      children:
        snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
    );

  },
  );
}

Widget _buildMessageItem(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  bool isCurrentUser = data['senderID'] == _chatService.getCurrentUser()!.email;

  var alignment =
  isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

  return Container(
    alignment: alignment,
    child: Column(
      children: [
        ChatBubble(
          message: data["message"],
          isCurrentUser: isCurrentUser,
        )
      ],
    ),
  );

}




Widget _buildUserInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Row(
  children: [
    const SizedBox(width: 20,),
    Expanded(
        child: TextField(
          minLines: 1,
          maxLines: 5,
          controller: _messageController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Nachricht...",
          ),
        ),
    ),
    const SizedBox(width: 10,),
    Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        shape: BoxShape.circle,
      ),
      margin: const EdgeInsets.only(right: 20),
      child: IconButton(
        onPressed: sendMessage,
        icon: const Icon(Icons.arrow_upward,
        ),
      ),
    ),
  ],
),

    );
}


}
