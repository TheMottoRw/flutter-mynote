import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constants/routes.dart';

import '../utilities.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  late final TextEditingController _email, _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(
                hintText: "Enter your email address here"),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
                hintText: "Enter your strong password here"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            ),
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                print(userCredential);
                if (!userCredential.user!.emailVerified) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                } else if (userCredential.user!.emailVerified) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                }
              } on FirebaseAuthException catch (e) {
                String text = "";
                switch(e.code){
                  case "user-not-found":
                    text = "User account does not exist";break;
                  case "invalid-email":
                    text = "Invalid email address";break;
                  case "invalid-credential":
                    text = "Wrong email or password";break;
                  default:
                    text = e.code;
                }
                await showErrorDialog(context, text);
                print(e.code);
              } catch (e) {
                await showErrorDialog(context, e.toString());

                print("Something bad happened");
              }
            },
          ),
          TextButton(
            child: const Text(
              "Not registered yet? Register here",
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
