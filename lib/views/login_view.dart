import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
          title: const Text("Login form"), backgroundColor: Colors.green),
      body: FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    decoration:
                    InputDecoration(hintText: "Enter your email address here"),
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _password,
                    decoration: InputDecoration(
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
                      try{
                        final email = _email.text;
                        final password = _password.text;
                        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        print(userCredential);
                      }on FirebaseAuthException catch(e){
                        print(e.code);
                      }catch(e){
                        print("Something bad happened");
                      }

                    },
                  ),
                ],
              );
            default: return const Text("Loading...");

          }
        },
      ),
    );
  }
}
