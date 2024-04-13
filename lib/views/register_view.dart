import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../firebase_options.dart';
import '../utilities.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: Text("Create account")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration:
            const InputDecoration(hintText: "Enter your email address here"),
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
              "Register",
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            ),
            onPressed: () async {
              String text = "";
              try{
                final email = _email.text;
                final password = _password.text;
                await AuthService.firebase().createUser(
                    email: email, password: password);

                final user = AuthService.firebase().currentUser;
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context)
                    .pushNamed(verifyRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(context, "Weak password");

              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, "Email already used");

              } on InvalidEmailAuthException {
                await showErrorDialog(context, "Invalid email address");

              } on GenericAuthException {
                await showErrorDialog(context, "Failed to register");
              }
            },
          ),
          TextButton(
            child: const Text(
              "Already have an account? Login",
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            ),
            onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,(route)=>false);
            },
          ),
        ],
      ),
    );
  }
}
