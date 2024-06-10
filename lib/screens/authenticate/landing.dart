import 'package:flutter/material.dart';
import 'package:hangout/screens/authenticate/Login.dart';
import 'package:hangout/screens/authenticate/register.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text('Organize. Invite. Enjoy. The Easy Way'),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text('Log in')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Text('Join for free'))
          ],
        ));
  }
}
