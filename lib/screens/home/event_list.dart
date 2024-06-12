import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    // final userData = Provider.of<UserModel?>(context);
    final String uid = user!.uid;
    final events = Provider.of<List<Event>?>(context);
    List<Event>? userEvents =
        events?.where((event) => event.ownerUid == uid).toList();

    if (userEvents == null || userEvents.isEmpty) {
      return const Center(
        child: Text('No userEvents available'),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: userEvents.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 160,
                  height: 160, // Adjust the size as needed
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(8), // Adjust the radius as needed
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10), // Same radius as above
                    child: Image.network(
                      userEvents[index].imageUrl,
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
                        return const Center(
                          child: Text('Error loading image'),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(userEvents[index].name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(userEvents[index].location,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
