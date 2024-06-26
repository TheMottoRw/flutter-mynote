import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify email"),),
      body: Column(
          children: [
            const Text("Email verification link has been sent to your email"),
            const Text("If you haven't received verification email,press the button below"),
            TextButton(onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            }, child: Text("Send email verification")),
            TextButton(onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            }, child: Text("Restart"))
          ],
        ),
    );
  }
}
