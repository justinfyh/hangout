import 'package:flutter/material.dart';
import 'package:hangout/screens/event/event_page.dart';
import 'package:hangout/models/event.dart';

class ExploreSection extends StatelessWidget {
  final List<Event> events;

  const ExploreSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    // Check if events list is empty
    if (events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // If there are events, display the first event
    return GestureDetector(
      onTap: () {
        // Navigate to event page passing eventId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(
              eventId: events[0].eventId,
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              borderRadius: BorderRadius.circular(15.0), // Border radius
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(15.0), // Border radius for image
              child: Stack(
                children: [
                  Image.network(events[0].imageUrl),
                  Positioned(
                    top: 10, // Position the text at the top
                    left: 10, // Position the text from the left
                    child: Text(
                      events[0].name,
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
