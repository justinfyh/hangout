import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class ListFriends extends StatelessWidget {
  const ListFriends({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final userData = Provider.of<UserModel?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);

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
            scrollDirection: Axis.vertical,
            itemCount: userData?.friends.length ?? 0,
            itemBuilder: (context, index) {
              final friendUid = userData?.friends[index];
              if (friendUid == null) {
                return const SizedBox.shrink();
              }
              return FutureBuilder<UserModel?>(
                future: db.getUserById(friendUid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.all(8.0),
                      child: const Column(
                        children: [
                          CircleAvatar(
                              radius: 30, child: CircularProgressIndicator()),
                          SizedBox(height: 8),
                          Text('Loading...', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.all(8.0),
                      child: const Column(
                        children: [
                          CircleAvatar(radius: 30, child: Icon(Icons.error)),
                          SizedBox(height: 8),
                          Text('Error', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.all(8.0),
                      child: const Column(
                        children: [
                          CircleAvatar(radius: 30, child: Icon(Icons.person)),
                          SizedBox(height: 8),
                          Text('No Data', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  }

                  UserModel friend = snapshot.data!;
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          // Replace with your own image handling
                          // backgroundImage: NetworkImage(friend.profileImageUrl),
                        ),
                        const SizedBox(height: 8),
                        Text(friend.name, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
