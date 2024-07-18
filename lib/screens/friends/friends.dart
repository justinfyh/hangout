// friends.dart
import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/friends/add-friends.dart'; // Import the new screen
import 'package:hangout/screens/friends/list_friends.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class Friends extends StatelessWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final String uid = user!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text('Friends', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add,
                color: Colors.black), // Add friend icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFriends(uid: uid)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search for friends...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_add,
                        color: Colors.black), // Add friend icon
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddFriends(uid: uid)),
                      );
                    },
                  ),
                ],
              ),
            ),
            const ListFriends(),
          ],
        ),
      ),
    );
  }
}
