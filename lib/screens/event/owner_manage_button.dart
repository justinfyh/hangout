import 'package:flutter/material.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/event/edit_event.dart';
import 'package:hangout/screens/event/invite_friends.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class OwnerManageButton extends StatelessWidget {
  final String eventId;

  const OwnerManageButton({required this.eventId});

  Future<void> _navigateToEditPage(BuildContext context, String eventId) async {
    final user = Provider.of<UserIdentity?>(context, listen: false);
    if (user == null) {
      // Handle the case where the user is not logged in
      return;
    }

    final db = DatabaseService(uid: user.uid);
    try {
      final event = await db.getEventById(eventId);
      if (event != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditEventPage(event: event),
          ),
        );
      } else {
        // Handle the case where the event is not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event not found')),
        );
      }
    } catch (e) {
      // Handle errors (e.g., network errors)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching event details')),
      );
    }
  }

  Future<void> _showManageOptions(BuildContext context) async {
    final user = Provider.of<UserIdentity?>(context, listen: false);
    if (user == null) {
      // Handle the case where the user is not logged in
      return;
    }

    final db = DatabaseService(uid: user.uid);
    try {
      final event = await db.getEventById(eventId);
      if (event != null) {
        // Build the bottom sheet with conditional invite option
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                      onTap: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                        _navigateToEditPage(context, eventId);
                      },
                    ),
                    if (event
                        .isPrivate) // Conditionally display "Invite" option
                      ListTile(
                        leading: Icon(Icons.person_add),
                        title: Text('Invite'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the bottom sheet
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InviteFriendsPage(eventId: eventId),
                            ),
                          );
                        },
                      ),
                    SizedBox(
                      height: 50,
                    )
                    // ListTile(
                    //   leading: Icon(Icons.link),
                    //   title: Text('Copy invitation link'),
                    //   onTap: () {
                    //     // Copy invitation link logic
                    //   },
                    // ),
                  ],
                ),
              ),
            );
          },
        );
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFFF7A00)
            .withOpacity(1), // Orange color with 100% opacity
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize:
            Size(double.infinity, 30), // Adjusted height to 48 for consistency
        padding: EdgeInsets.symmetric(vertical: 8), // Adjusted padding
      ),
      onPressed: () {
        _showManageOptions(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Manage',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Icon(Icons.arrow_drop_down), // Dropdown icon
        ],
      ),
    );
  }
}
