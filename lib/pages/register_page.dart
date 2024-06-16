
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_button.dart';
import 'package:socialmediaapp/components/my_textfield.dart';

import '../helper/helper_functions.dart';


class RegisterPage extends StatefulWidget {

  //register Methode
  final void Function()? onTap;



  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  final TextEditingController childcodeController = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'Kita',
    'Eltern',
  ];
  var _currentItemSelected = "Eltern";
  var rool = "Eltern";
  String adress = "Noch nicht angegeben...";
  String adress2 = "Noch nicht angegeben...";
  String tel = "Noch nicht angegeben...";
  String childcode = "";


  bool showProgress = false;
  bool visible = false;



  // register methode
  void registerUser() async {
    // ladekreis anzeigen
    showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),

        )
    );

    // passwort übereinstimmung prüfen
    if (passwordController.text != confirmPwController.text)
    {
      Navigator.pop(context);
      // Fehlermeldung für Benutzer
      displayMessageToUser("Passwörter stimmen nicht überein", context);


    }
    // wenn Passwörter übereinstimmen
    else {
      // Benutzer erstellen
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,

        );


        //// Dokument für Benutzer in Firestore erstellen

        createUserDocument(userCredential);

        //// Dokument für Benutzer in Firestore erstellen

        // Ladekreis


        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Ladekreis
        Navigator.pop(context);

        // Fehlermeldung anzeigen
        displayMessageToUser(e.code, context);
      }
    }
  }

  //// Dokument für Firestone erstellen und mit Benutzerdaten füllen, Name = Users

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null && _currentItemSelected == "Eltern") // prüfen ob Felder leer & ob Eltern
        {
      await FirebaseFirestore.instance //Dokument erstellen
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'rool': rool,
        'adress': adress,
        'adress2': adress2,
        'tel': tel,
        'childcode': "",
        "kitamail": "",
        'timestamp': Timestamp.now(),
      });
    }
    else if (userCredential != null && userCredential.user != null && _currentItemSelected == "Kita") // prüfen ob Felder leer und ob Kita
        {
      await FirebaseFirestore.instance //Dokument erstellen
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'rool': rool,
        'adress': adress,
        'adress2': adress2,
        'tel': tel,
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const SizedBox(height: 50,),
              // logo
              Icon(
                Icons.person,
                size: 80,
              ),

              // app name

              const Text(
                "Registrieren",
                style: TextStyle(fontSize: 20),

              ),

              const SizedBox(height: 40),

              // Username textfield

              MyTextField(
                hinText: "Name",
                obscureText: false,
                controller: usernameController,
              ),

              const SizedBox(height: 10),

              // Email textfield

              MyTextField(
                hinText: "Email",
                obscureText: false,
                controller: emailController,

              ),

              const SizedBox(height: 45),

              // password textfield

              MyTextField(
                hinText: "Password",
                obscureText: true, // Text nicht anzeigen
                controller: passwordController,

              ),

              const SizedBox(height: 10),

              // password confirm

              MyTextField(
                hinText: "Password bestätigen",
                obscureText: true, // Text nicht anzeigen
                controller: confirmPwController,

              ),



              const SizedBox(height: 10),


              DropdownButton<String>(
                isDense: true,
                isExpanded: false,
                items: options.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(
                      dropDownStringItem,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValueSelected) {
                  setState(() {
                    _currentItemSelected = newValueSelected!;
                    rool = newValueSelected;
                  });
                },
                value: _currentItemSelected,
              ),

              const SizedBox(height: 10),
            /*if (_currentItemSelected == "Eltern")


              MyTextField(
                hinText: "Aktivierungscode",
                obscureText: false,
                controller: childcodeController,
              ),

              */
              const SizedBox(height: 30),

              //Register in button

              MyButton(
                text: "Registrieren",
                onTap: registerUser,
              ),

              const SizedBox(height: 10),

              // Register here

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sie haben bereits einen Account? ",
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Hier einloggen",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
