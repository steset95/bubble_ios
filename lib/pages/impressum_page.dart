

import 'package:flutter/material.dart';


class ImpressumPage extends StatefulWidget {


  const ImpressumPage({super.key});

  @override
  State<ImpressumPage> createState() => ImpressumPageState();
}

class ImpressumPageState extends State<ImpressumPage> {





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
    title: Text("Impressum",
    style: TextStyle(color:Colors.black),
    ),
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
                        "ABGs",
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

