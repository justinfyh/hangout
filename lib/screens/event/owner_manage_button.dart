import 'package:flutter/material.dart';

class OwnerManageButton extends StatelessWidget {
  final String eventId;

  const OwnerManageButton({required this.eventId});

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
                        // Navigate to the edit event page
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
