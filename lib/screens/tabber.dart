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
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300, // Subtle grey color for the border
              width: 0.8, // Border width
            ),
          ),
        ),
        child: const TabBar(
          indicatorColor: Color(0xffFF7A00),
          labelColor: Color(0xffFF7A00),
          unselectedLabelColor:
              Colors.grey, // Set the unselected label color to grey
          tabs: [
            Tab(icon: Icon(Icons.home_outlined)),
            Tab(icon: Icon(Icons.people_alt_outlined)),
            Tab(icon: Icon(Icons.add_box_outlined)),
            Tab(icon: Icon(Icons.access_alarm)),
            Tab(icon: Icon(Icons.person_2_outlined)),
          ],
        ),
      ),
    );
  }
}
