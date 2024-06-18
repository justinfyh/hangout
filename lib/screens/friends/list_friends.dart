import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class ListFriends extends StatefulWidget {
  const ListFriends({super.key});

  @override
  _ListFriendsState createState() => _ListFriendsState();
}

class _ListFriendsState extends State<ListFriends> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: _fetchFriends(db, user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching friends'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No friends found'));
                }

                List<UserModel> friends = snapshot.data!.where((friend) {
                  return friend.name.toLowerCase().contains(searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    UserModel friend = friends[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: friend.profileImageUrl != null &&
                                friend.profileImageUrl.isNotEmpty
                            ? NetworkImage(friend.profileImageUrl)
                            : const AssetImage('assets/images/mascot.png'),
                      ),
                      title: Text(friend.name),
                      // subtitle: Text('Last Hangout ${friend.lastHangout}'),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          // Handle more options
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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
