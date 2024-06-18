import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class FriendSection extends StatelessWidget {
  const FriendSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);

    return FutureBuilder<List<UserModel>>(
      future: _fetchFriends(db, user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching friends'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No friends found'));
        }

        List<UserModel> friends = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Friends',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  UserModel friend = friends[index];
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: friend.profileImageUrl != null &&
                                  friend.profileImageUrl.isNotEmpty
                              ? NetworkImage(friend.profileImageUrl)
                              : const AssetImage('assets/images/mascot.png'),
                        ),
                        const SizedBox(height: 8),
                        Text(friend.name, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<UserModel>> _fetchFriends(DatabaseService db, String uid) async {
    List<String> friendIds = await db.getFriends(uid);
    List<UserModel> friends = [];
    for (String friendId in friendIds) {
      UserModel? friend = await db.getUserById(friendId);
      if (friend != null) {
        friends.add(friend);
      }
    }
    return friends;
  }
}
