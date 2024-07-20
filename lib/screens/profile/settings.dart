import 'package:flutter/material.dart';
import 'package:hangout/services/auth.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
