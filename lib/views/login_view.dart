import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import 'package:mynotes/utilities.dart';

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
                AuthService.firebase().login(email: email, password: password);
                final userCredential = AuthService.firebase().currentUser;
                print(userCredential);
                if(userCredential==null) throw WrongPasswordAuthException();
                if (userCredential?.isEmailVerified ?? false) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                }
              } on UserNotFoundAuthException{
                await showErrorDialog(context, "User not found");
              } on WrongPasswordAuthException{
                await showErrorDialog(context, "Wrong  credentials");
              } on GenericAuthException{
                await showErrorDialog(context, "Authentication error");
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
