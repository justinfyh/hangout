import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/screens/home/event_list.dart';
import 'package:hangout/services/auth.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  final DatabaseService _database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    String? email = user?.email;
    return StreamProvider<List<Event>?>.value(
      value: DatabaseService().events,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text(email ?? "no user logged in"),
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    child: const Text('Log Out'))),
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await _database.createEvent();
                    },
                    child: const Text('Create Event'))),
            EventList(),
          ],
        ),
      ),
    );
  }
}
