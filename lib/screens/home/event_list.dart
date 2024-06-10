import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<Event>?>(context);

    if (events == null || events.isEmpty) {
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
          return Container(
            width: 150,
            margin: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expanded(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(8.0),
                //       image: DecorationImage(
                //         image: AssetImage(
                //             'gs://hangout-ef87b.appspot.com/westfield-albany.jpg'), // Replace with your own images
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 8),
                Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/hangout-ef87b.appspot.com/o/westfield-albany.jpg?alt=media',
                  // Specify your Firebase Storage URL here
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Error loading image');
                  },
                ),
                Text(events[index].name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(events[index].location,
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
