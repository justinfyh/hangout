import "package:flutter/material.dart";
import "package:hangout/screens/authenticate/landing.dart";
import "package:hangout/screens/authenticate/login.dart";
import "package:hangout/screens/authenticate/register.dart";

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    return const Landing();
  }
}
