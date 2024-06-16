
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_button.dart';
import 'package:socialmediaapp/components/my_textfield.dart';
import 'package:socialmediaapp/helper/helper_functions.dart';

import 'forgot_password_page.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Login MEhtod
  void login() async{
    // ladekreis anzeigen
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // ladekreis anzeigen
      if (context.mounted) Navigator.pop(context);
    }
    // Fehlermeldung anzeigen

    on FirebaseAuthException catch (e) {
      // ladekreis anzeigen
      Navigator.pop(context);
      displayMessageToUser("Benutzername oder Passwort falsch", context);

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                "Login",
                style: TextStyle(fontSize: 20),

              ),

              const SizedBox(height: 80),

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

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  GestureDetector(
                    child: Text(
                      "Passwort vergessen? ",
              ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              //sing in button

              MyButton(
                text: "Login",
                onTap: login,
              ),

              const SizedBox(height: 10),

              // Register here

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Noch keinen Account? ",
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Hier registrieren",
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

