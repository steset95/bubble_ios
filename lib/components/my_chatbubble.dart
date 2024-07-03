import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String datum;
  final String uhrzeit;

  const ChatBubble({
    required this.message,
    required this.isCurrentUser,
    required this.datum,
    required this.uhrzeit,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isCurrentUser ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            child: Text(
                message,
            style: TextStyle(color: Colors.white),
            ),
        ),
        Text(
          datum,
          style: TextStyle(color:Colors.black,
            fontSize: 10,
          ),
        ),
        Text(
          uhrzeit,
          style: TextStyle(color:Colors.black,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
