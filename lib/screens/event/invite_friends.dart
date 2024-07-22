import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/components/search_bar.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class InviteFriendsPage extends StatefulWidget {
  final String eventId;

  InviteFriendsPage({required this.eventId});

  @override
  _InviteFriendsPageState createState() => _InviteFriendsPageState();
}

class _InviteFriendsPageState extends State<InviteFriendsPage> {
  String searchQuery = '';
  List<UserModel> friends = [];
  List<UserModel> selectedFriends = [];

  @override
  void initState() {
    super.initState();
    _loadEventAndFriends();
  }

  Future<void> _loadEventAndFriends() async {
    final user = Provider.of<UserIdentity?>(context, listen: false);
    final db = DatabaseService(uid: user!.uid);

    // Fetch event details to get invited users
    try {
      final event = await db.getEventById(widget.eventId);
      if (event != null) {
        // Set selected friends to those who are already invited
        final invitedUserIds = event.invited; // List of invited user IDs
        final allFriends = await _fetchFriends(db, user.uid);
        setState(() {
          friends = allFriends;
          selectedFriends = allFriends
              .where((friend) => invitedUserIds.contains(friend.uid))
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching event details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);

    return Scaffold(
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
            icon: const Icon(Icons.send, color: Colors.black),
            onPressed: () {
              _sendInvitations();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: friends.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: friends.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade300,
                thickness: 0,
              ),
              itemBuilder: (context, index) {
                UserModel friend = friends.elementAt(index);
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
                  trailing: Checkbox(
                    value: selectedFriends.contains(friend),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          selectedFriends.add(friend);
                        } else {
                          selectedFriends.remove(friend);
                        }
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                );
              },
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

  void _sendInvitations() async {
    final user = Provider.of<UserIdentity?>(context, listen: false);
    final db = DatabaseService(uid: user!.uid);

    try {
      // Fetch current invited users
      final event = await db.getEventById(widget.eventId);
      if (event != null) {
        final currentInvited = Set<String>.from(event.invited);

        // Get user IDs from selected friends
        final newInvitations =
            selectedFriends.map((friend) => friend.uid).toSet();

        // Determine which users to add or remove
        final toInvite = newInvitations.difference(currentInvited).toList();
        final toRemove = currentInvited.difference(newInvitations).toList();

        // Update event invitations
        await db.updateEventInvitations(
          eventId: widget.eventId,
          toAdd: toInvite,
          toRemove: toRemove,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending invitations')),
      );
    }
  }
}
