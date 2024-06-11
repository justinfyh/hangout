import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/home/event_explore.dart';
import 'package:hangout/screens/home/event_list.dart';
import 'package:hangout/screens/home/event_month.dart';
import 'package:hangout/screens/home/event_tabs.dart';
import 'package:hangout/screens/home/friends_list.dart';
import 'package:hangout/services/auth.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final userData = Provider.of<UserModel?>(context);
    // final eventData = Provider.of<List<Event>?>(context);
    final String uid = user!.uid;

    final DatabaseService _database = DatabaseService(uid: uid);

    return StreamProvider<List<Event>?>.value(
      value: DatabaseService(uid: uid).events,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          // elevation: 0,
          // bottom:
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          title: const Text('Hangout', style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(userData?.name ?? "no email"),
              Text(uid),
              Text(userData?.email ?? "no email"),
              EventTabs(),
              MonthlyEvents(),
              EventList(),
              FriendSection(),
              ExploreSection(),
              Center(
                  child: FilledButton(
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
              Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        await _database.addFriend(user.uid);
                      },
                      child: const Text('Add Friend'))),
            ],
          ),
        ),
      ),
    );
  }
}
