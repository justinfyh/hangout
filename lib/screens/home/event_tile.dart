import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';

class EventTile extends StatelessWidget {
  final Event event;
  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.8),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: Text('${event.name} where ${event.location}'),
      ),
    );
  }
}
