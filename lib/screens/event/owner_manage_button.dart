import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/event/edit_event.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';
// import 'edit_event_page.dart'; // Import the EditEventPage

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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return BottomSheet(
              onClosing: () {},
              builder: (BuildContext context) {
                return Column(
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
                    ListTile(
                      leading: Icon(Icons.person_add),
                      title: Text('Invite'),
                      onTap: () {
                        // Show invite options
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.link),
                      title: Text('Copy invitation link'),
                      onTap: () {
                        // Copy invitation link
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      child: const Text('Manage'),
    );
  }
}
