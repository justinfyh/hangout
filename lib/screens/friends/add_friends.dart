import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/services/database.dart';

class AddFriends extends StatefulWidget {
  final String uid;
  const AddFriends({Key? key, required this.uid}) : super(key: key);

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  String searchQuery = '';
  List<UserModel> searchResults = [];

  void searchUsers(String query) async {
    if (query.isNotEmpty) {
      final results = await DatabaseService(uid: widget.uid).searchUsers(query);
      setState(() {
        searchQuery = query;
        searchResults = results;
      });
    } else {
      setState(() {
        searchQuery = '';
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Friends', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for friends...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: searchUsers,
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? const Center(child: Text('No results found'))
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final user = searchResults[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profileImageUrl),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.bio),
                        trailing: IconButton(
                          icon: const Icon(Icons.person_add),
                          onPressed: () {
                            DatabaseService(uid: widget.uid)
                                .sendFriendRequest(widget.uid, user.uid);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
