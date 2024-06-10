import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangout/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    String? email = user?.email;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(email ?? "no user logged in"),
          Center(
              child: ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: const Text('Log Out')))
        ],
      ),
    );
  }
}
