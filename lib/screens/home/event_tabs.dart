import 'package:flutter/material.dart';

class EventTabs extends StatelessWidget {
  const EventTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Chip(
            label: Text('My Events', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.orange,
          ),
          Chip(
            label: Text('Friend\'s Events'),
          ),
          Chip(
            label: Text('Local'),
          ),
          Icon(Icons.search),
        ],
      ),
    );
  }
}
