import 'package:flutter/material.dart';
import 'package:hangout/screens/event/event_page.dart';
import 'package:hangout/models/event.dart';

class ExploreSection extends StatelessWidget {
  final List<Event> events;

  const ExploreSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final event = events[0];
    return GestureDetector(
      onTap: () {
        // Navigate to event page passing eventid
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(
              eventId: event.eventId,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              'Explore',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              'See what\'s happening around you',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              // Border color and width
              borderRadius: BorderRadius.circular(15.0), // Border radius
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(15.0), // Border radius for image
              child: Stack(
                children: [
                  Image.network(event.imageUrl),
                  Positioned(
                    top: 10, // Position the text at the top
                    left: 10, // Position the text from the left
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        // backgroundColor: Colors.black.withOpacity(
                        //     0.5), // Text background color with opacity
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
