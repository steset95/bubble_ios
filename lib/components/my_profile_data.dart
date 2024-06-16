import 'package:flutter/material.dart';

class ProfileData extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const ProfileData({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,

  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return  Container(
      width: mediaQuery.size.width * 1,
        decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,),
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
          Text(text,
            style: TextStyle(color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
        );
  }
}


