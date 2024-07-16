import 'package:flutter/material.dart';

class ProfileDataReadOnly extends StatelessWidget {
  final String text;
  final String sectionName;


  const ProfileDataReadOnly({
    super.key,
    required this.text,
    required this.sectionName,

  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return  Container(
      width: mediaQuery.size.width * 1,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(2, 4),
          ),
        ],
          //border: Border.all(color: Colors.black)
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15, top: 15),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,),
              ),
            ],
          ),
          const SizedBox(height: 5,),
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
