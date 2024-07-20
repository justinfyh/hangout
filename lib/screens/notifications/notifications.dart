import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    final userData = Provider.of<UserModel?>(context);
    final String uid = user!.uid;
    final DatabaseService db = DatabaseService(uid: uid);

    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: userData.requests.length,
        itemBuilder: (context, index) {
          final request = userData.requests[index];
          return FutureBuilder<UserModel?>(
            future: db.getUserById(request),
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
              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(friend.profileImageUrl),
                ),
                title: Text(
                  friend.name,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'wants to be your friend',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle accept action
                        db.acceptFriendRequest(uid, friend.uid);
                      },
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.orange,
                        // onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Border radius
                        ),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 6),
                    OutlinedButton(
                      onPressed: () {
                        // Handle delete action
                        db.declineFriendRequest(uid, friend.uid);
                      },
                      style: OutlinedButton.styleFrom(
                        // primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Border radius
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
