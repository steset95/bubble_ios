
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_button.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import 'package:socialmediaapp/helper/helper_functions.dart';


class ForgotPasswordPage extends StatefulWidget {


  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {

  final TextEditingController emailController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
              const SizedBox(height: 50,),
              // logo
              Icon(
                Icons.person,
                size: 80,
              ),
              // app name

              const Text(
                "Passwort vergessen",
                style: TextStyle(fontSize: 20),

              ),

              const SizedBox(height: 80),

              // Email textfield
              const Text(
                "Email für Widerherstellungslink eintragen:",
                style: TextStyle(fontSize: 12),

              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,

              ),

              const SizedBox(height: 40),



              //sing in button

              MyButton(
                text: "Email anfordern",
                onTap: resetPassword,
              ),
              const SizedBox(height: 10),

            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
    Navigator.of(context).pop();
  }


}

