import 'package:flutter/material.dart';

class EventTabs extends StatelessWidget {
  const EventTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Chip(
            label: Text('My Events', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Chip(
            label: Text('Friend\'s Events'),
            backgroundColor: Colors.white24,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Chip(
            label: Text('Local'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Icon(Icons.search),
        ],
      ),
    );
  }
}
