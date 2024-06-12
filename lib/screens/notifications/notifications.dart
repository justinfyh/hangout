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
        appBar: AppBar(title: const Text('Notifications')),
        body: ListView.builder(
          itemCount: userData.requests.length,
          itemBuilder: (context, index) {
            final request = userData.requests[index];
            final user = db.getUserById(request);
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
                return Container(
                  width: 80,
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(friend.profileImageUrl),
                      ),
                      const SizedBox(height: 8),
                      Text('${friend.name} sent you a friend request',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
