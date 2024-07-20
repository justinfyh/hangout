import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/components/search_bar.dart';
import 'package:hangout/screens/friends/add_friends.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';
// import 'package:timeago/timeago.dart' as timeago;

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
        backgroundColor: Colors.white,
        title: CustomSearchBar(
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddFriends(uid: user.uid)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
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

                return ListView.separated(
                  itemCount: friends.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.shade300,
                    thickness: 0,
                    // indent: 16,
                    // endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    UserModel friend = friends[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: friend.profileImageUrl.isNotEmpty
                            ? NetworkImage(friend.profileImageUrl)
                            : const AssetImage('assets/images/mascot.png')
                                as ImageProvider,
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(friend.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      // subtitle: Text(
                      //     'Last Hangout ${timeago.format(friend.lastHangout)}',
                      //     style: TextStyle(color: Colors.grey)),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Handle more options
                        },
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
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
