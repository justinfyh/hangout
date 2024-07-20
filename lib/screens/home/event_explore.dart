import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hangout/models/event.dart';

class ExploreSection extends StatelessWidget {
  final List<Event> events;

  const ExploreSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10, 0, 0),
          child: Text(
            'Explore Other Events ${events.isNotEmpty ? events[0].name : ''}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            'See what\'s happening around you',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        // Add more widgets to display the list of events
        // For example, you could use a ListView.builder to display each event
      ],
    );
  }
}
