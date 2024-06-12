import 'package:flutter/material.dart';
import 'package:hangout/screens/authenticate/register.dart';
import 'package:hangout/screens/create-event/create_event.dart';
import 'package:hangout/screens/friends/friends.dart';
import 'package:hangout/screens/home/home.dart';
import 'package:hangout/screens/notifications/notifications.dart';
import 'package:hangout/screens/profile/profile.dart';

class Tabber extends StatelessWidget {
  const Tabber({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: [
          Home(),
          Friends(),
          CreateEventPage(),
          Notifications(),
          Profile()
          // ProfileTab(),
          // SettingsTab(),
        ],
      ),
      bottomNavigationBar: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.person_add)),
          Tab(icon: Icon(Icons.add_box)),
          Tab(icon: Icon(Icons.access_alarm)),
          Tab(icon: Icon(Icons.person_2)),
          // Tab(icon: Icon(Icons.person_2), text: 'Profile'),
        ],
      ),
    );
  }
}
