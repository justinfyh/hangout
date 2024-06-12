import 'package:flutter/material.dart';
import 'package:hangout/screens/authenticate/register.dart';
import 'package:hangout/screens/create-event/create_event.dart';
import 'package:hangout/screens/friends/friends.dart';
import 'package:hangout/screens/home/home.dart';
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
          Profile()
          // ProfileTab(),
          // SettingsTab(),
        ],
      ),
      bottomNavigationBar: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.home), text: 'Home'),
          Tab(icon: Icon(Icons.person), text: 'Friends'),
          Tab(icon: Icon(Icons.add), text: 'Create'),
          Tab(icon: Icon(Icons.person_2), text: 'Profile'),
        ],
      ),
    );
  }
}
