
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import '../../helper/helper_functions.dart';




class AddKindPageEltern extends StatefulWidget {

  AddKindPageEltern({
    super.key,
  });



  @override
  State<AddKindPageEltern> createState() => _AddKindPageElternState();
}

class _AddKindPageElternState extends State<AddKindPageEltern> {


  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController textController = TextEditingController();

  void addChildCode(String childcode) async{

    await FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .get()
        .then((DocumentSnapshot document) {
      if (document["registrierungen"] > 3) {

        return displayMessageToUser("Zu viele verschiedene Mail-Adressen verwendet.", context);
      }
      else {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .update({
      "childcode": childcode,
    });
    }
      var registrierungen = document["registrierungen"];
      int reg = (registrierungen + 1);
      FirebaseFirestore.instance
          .collection("Kinder")
          .doc(childcode)
          .update({"registrierungen": reg});
    });
  }

  /// Eltern Mail in Kind hinzufügen

  void addElternMail(String childcode) {
    FirebaseFirestore.instance
        .collection("Kinder")
        .doc(childcode)
        .update({
      "eltern" : currentUser?.email,
    });
  }



  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: Text("Kind hinzufügen",
            ),
          ),
        body:
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Text("Bitte den Aktivierungsschlüsser von Ihrer Kita eingeben:"),
                const SizedBox(height: 20,),
                MyTextField(hintText: "Aktivierungsschlüssel...", obscureText: false, controller: textController),
                const SizedBox(height: 20,),
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("Kinder")
                        .doc(textController.text)
                        .get()
                        .then((DocumentSnapshot document) {
                      if (document.exists) {
                        addChildCode(textController.text);
                        addElternMail(textController.text);
                        // Textfeld leeren nach Eingabe
                        textController.clear();
                        //Box schliessen
                        Navigator.pop(context);

                        displayMessageToUser("Kind wird hinzugefügt...", context);
                      }
                      else {
                        return displayMessageToUser("Aktivierungscode ist unglütig.", context);
                      }
                    }
                    );
                  }, child: Text("Kind Hinzufügen"),
                ),
              ],
            ),
          ),
    )
      );

    }
    }






