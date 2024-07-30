

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
      scrolledUnderElevation: 0.0,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    title: Text("Impressum",
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
                      Image.asset("assets/images/Logo_1.png", width: 140, height:100),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          const Text(
                            "Kontakt",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Tanzschule Dance More GmbH",
                            style: TextStyle(fontSize: 12),
                          ),
                          const Text(
                            "Gewerbestrasse 3",
                            style: TextStyle(fontSize: 12),
                          ),
                          const Text(
                            "8500 Frauenfeld",
                            style: TextStyle(fontSize: 12),

                          ),
                        ],
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

