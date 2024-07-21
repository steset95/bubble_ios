
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_button.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import 'package:socialmediaapp/helper/helper_functions.dart';


class DatenschutzrichtlinienPage extends StatefulWidget {


  const DatenschutzrichtlinienPage({super.key});

  @override
  State<DatenschutzrichtlinienPage> createState() => DatenschutzrichtlinienPageState();
}

class DatenschutzrichtlinienPageState extends State<DatenschutzrichtlinienPage> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade300,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.book,
                        size: 80,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Datenschutzrichtlinien",
                        style: TextStyle(fontSize: 20),

                      ),
                    ],
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

