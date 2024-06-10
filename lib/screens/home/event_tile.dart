import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';

class EventTile extends StatelessWidget {
  final Event event;
  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/event_$index.jpg'), // Replace with your own images
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(event.name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Event Date and Time',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
