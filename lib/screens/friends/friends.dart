import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/friends/list_friends.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class Friends extends StatelessWidget {
  const Friends({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final String uid = user!.uid;

    final DatabaseService db = DatabaseService(uid: uid);

    return Scaffold(
      backgroundColor: Colors.white, // Set background color here
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text('Friends', style: TextStyle(color: Colors.black)),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add via username...',
                      ),
                      onSubmitted: (username) {
                        // Perform add friend operation using uid
                        db.sendFriendRequest(uid, username);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Alternatively, you can use a button to trigger the action
                      // db.addFriend(uid, _username.text);
                    },
                  ),
                ],
              ),
            ),
            ListFriends(),
          ],
        ),
      ),
    );
  }
}
