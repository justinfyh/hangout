import 'package:flutter/material.dart';
import 'package:hangout/services/auth.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  void _logout() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
              child: ElevatedButton(
                  onPressed: _logout, child: const Text('Log Out')))
        ],
      ),
    );
  }
}
