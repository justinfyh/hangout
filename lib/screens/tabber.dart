import 'package:flutter/material.dart';
import 'package:hangout/screens/create-event/create_event.dart';
import 'package:hangout/screens/friends/list_friends.dart';
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
          ListFriends(),
          CreateEventPage(),
          Notifications(),
          Profile()
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: const TabBar(
          indicatorColor: Color(0xffFF7A00),
          labelColor: Color(0xffFF7A00),
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.person_add)),
            Tab(icon: Icon(Icons.add_box)),
            Tab(icon: Icon(Icons.access_alarm)),
            Tab(icon: Icon(Icons.person_2)),
          ],
        ),
      ),
    );
  }
}
