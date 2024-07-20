import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
// import 'package:hangout/models/user.dart';
import 'package:hangout/screens/event/event_page.dart';
// import 'package:provider/provider.dart';

class EventList extends StatelessWidget {
  final List<Event> events;

  const EventList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserIdentity?>(context);
    // final String uid = user!.uid;

    if (events.isEmpty) {
      return const Center(
        child: Text('No events available'),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final imageUrl = event.imageUrl.isNotEmpty &&
                  Uri.tryParse(event.imageUrl)?.hasAbsolutePath == true
              ? event.imageUrl
              : 'https://firebasestorage.googleapis.com/v0/b/hangout-ef87b.appspot.com/o/placeholder%2FMeditation.png?alt=media&token=9c4c6c73-643c-482c-aab6-b50dba2fbf38'; // Path to your placeholder image

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
            child: Container(
              margin: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/mascot.png', // Path to your placeholder image
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(event.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(event.dateTime,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
