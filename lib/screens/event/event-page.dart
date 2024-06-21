import 'package:flutter/material.dart';
import 'package:hangout/models/event.dart';
import 'package:hangout/models/user.dart';
import 'package:hangout/screens/event/group_chat.dart';
import 'package:hangout/screens/event/status-button.dart';
import 'package:hangout/services/database.dart';
import 'package:provider/provider.dart';

class EventDetailsPage extends StatelessWidget {
  final String eventId;

  const EventDetailsPage({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserIdentity?>(context);
    DatabaseService db = DatabaseService(uid: user!.uid);

    return FutureBuilder<Event?>(
      future: db.getEventById(eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Event not found'));
        } else {
          final event = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,

              // title: Text('Event Details'),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      event.imageUrl != ""
                          ? Image.network(
                              event.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/mascot.png', // Path to your placeholder image
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/mascot.png', // Path to your placeholder image
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Chip(
                          label: Text(
                            event.dateTime,
                            // '${event.dateTime}, ${event.dateTime.month} at ${event.dateTime.hour}:${event.dateTime.minute}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        FutureBuilder<UserModel?>(
                          future: db.getUserById(event.ownerUid),
                          builder: (BuildContext context,
                              AsyncSnapshot<UserModel?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Text(
                                'Private · Event by ${snapshot.data!.name}',
                                style: const TextStyle(color: Colors.grey),
                              );
                            } else {
                              return const Text('No data found');
                            }
                          },
                        ),
                        const SizedBox(height: 10),

                        GoingButton(),

                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 5),
                            Text(event.location),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // CircleAvatar(radius: 10),
                            // CircleAvatar(radius: 10),
                            // CircleAvatar(radius: 10),
                            const Icon(Icons.check_circle_outline),
                            const SizedBox(width: 5),
                            Text(
                                '${event.going.length} going · ${event.interested.length} interested'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('What to expect',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(event.details),
                        const SizedBox(height: 20),
                        const Text('Party Chat',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        // Party chat bubbles example
                        // ListView(
                        //   shrinkWrap: true,
                        //   physics: NeverScrollableScrollPhysics(),
                        //   children: [
                        //     ChatBubble(text: 'Cool', isUser: false),
                        //     ChatBubble(
                        //         text: 'How does it work?', isUser: false),
                        //     ChatBubble(
                        //         text: 'You just edit any text...',
                        //         isUser: true),
                        //   ],
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupChatPage(
                                  eventId: eventId,
                                ),
                              ),
                            );
                          },
                          child: Text('Go to Group Chat'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

// class ChatBubble extends StatelessWidget {
//   final String text;
//   final bool isUser;

//   ChatBubble({required this.text, required this.isUser});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         margin: EdgeInsets.symmetric(vertical: 5),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.orange : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Text(text),
//       ),
//     );
//   }
// }
